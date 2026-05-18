param(
  [string]$SourceDir = "",
  [string]$OutputRoot = "references/history/selected-works-of-mao-tsetung",
  [string]$SourceRepo = "https://github.com/M0rtzz/Selected-Works-of-MaoTseTung",
  [string]$Ref = "HEAD",
  [string[]]$OnlyPath = @(),
  [string[]]$WordPath = @(),
  [switch]$ConvertWithWord,
  [int]$MaxWordConversions = 0
)

$ErrorActionPreference = "Stop"

function Resolve-SourceDir {
  param([string]$Value)

  if ($Value -and (Test-Path -LiteralPath $Value)) {
    return (Resolve-Path -LiteralPath $Value).Path
  }

  $pathFile = Join-Path $env:TEMP "mao-selected-works-src-path.txt"
  if (Test-Path -LiteralPath $pathFile) {
    $candidate = (Get-Content -LiteralPath $pathFile -Encoding UTF8 | Select-Object -First 1).Trim()
    if ($candidate -and (Test-Path -LiteralPath $candidate)) {
      return (Resolve-Path -LiteralPath $candidate).Path
    }
  }

  throw "SourceDir was not provided and no temp source clone was found."
}

function Invoke-Git {
  param(
    [string]$Repo,
    [string[]]$Arguments
  )

  $output = & git -c "safe.directory=$Repo" -c "core.quotepath=false" -C $Repo @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
  }
  return $output
}

function Get-GitBlobBytes {
  param(
    [string]$Repo,
    [string]$Sha
  )

  $psi = [System.Diagnostics.ProcessStartInfo]::new()
  $psi.FileName = "git"
  $quotedRepo = '"' + ($Repo -replace '"', '\"') + '"'
  $psi.Arguments = "-c `"safe.directory=$Repo`" -C $quotedRepo cat-file blob $Sha"
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true

  $process = [System.Diagnostics.Process]::Start($psi)
  $memory = [System.IO.MemoryStream]::new()
  $process.StandardOutput.BaseStream.CopyTo($memory)
  $stderr = $process.StandardError.ReadToEnd()
  $process.WaitForExit()

  if ($process.ExitCode -ne 0) {
    throw "git cat-file failed for ${Sha}: $stderr"
  }

  return $memory.ToArray()
}

function Convert-BytesToText {
  param([byte[]]$Bytes)

  if ($Bytes.Length -ge 3 -and $Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) {
    return [System.Text.Encoding]::UTF8.GetString($Bytes, 3, $Bytes.Length - 3)
  }

  try {
    $utf8 = [System.Text.UTF8Encoding]::new($false, $true)
    return $utf8.GetString($Bytes)
  }
  catch {
    $gbk = [System.Text.Encoding]::GetEncoding(936)
    return $gbk.GetString($Bytes)
  }
}

function ConvertTo-SafePath {
  param([string]$Path)

  $relative = $Path -replace '/', [System.IO.Path]::DirectorySeparatorChar
  $invalid = [System.IO.Path]::GetInvalidFileNameChars()
  $segments = $relative -split [regex]::Escape([System.IO.Path]::DirectorySeparatorChar)
  $safeSegments = foreach ($segment in $segments) {
    $chars = $segment.ToCharArray() | ForEach-Object {
      if ($invalid -contains $_) { "_" } else { $_ }
    }
    -join $chars
  }
  return ($safeSegments -join [System.IO.Path]::DirectorySeparatorChar)
}

function Write-MarkdownText {
  param(
    [string]$Root,
    [string]$SourcePath,
    [string]$Title,
    [string]$Text,
    [string]$Conversion,
    [string]$Commit,
    [string]$Repo
  )

  $safePath = ConvertTo-SafePath $SourcePath
  $targetRelative = "$safePath.md"
  $target = Join-Path (Join-Path $Root "corpus") $targetRelative
  $targetDir = Split-Path -Parent $target
  New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

  $sourcePathLabel = -join @(
    [char]0x6765
    [char]0x6E90
    [char]0x8DEF
    [char]0x5F84
    [char]0xFF1A
  )
  $conversionLabel = -join @(
    [char]0x8F6C
    [char]0x6362
    [char]0x65B9
    [char]0x5F0F
    [char]0xFF1A
  )
  $normalized = ($Text -replace "`r`n", "`n") -replace "`r", "`n"
  $body = @(
    "---"
    "source_repo: `"$Repo`""
    "source_commit: `"$Commit`""
    "source_path: `"$SourcePath`""
    "conversion: `"$Conversion`""
    "generated_at: `"$((Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ"))`""
    "---"
    ""
    "# $Title"
    ""
    ("> {0}{1}" -f $sourcePathLabel, $SourcePath)
    ("> {0}{1}" -f $conversionLabel, $Conversion)
    ""
    $normalized.Trim()
    ""
  ) -join "`n"

  $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
  [System.IO.File]::WriteAllText($target, $body, $utf8NoBom)
  return $target
}

function Convert-WithWordToText {
  param(
    [string]$InputPath,
    [string]$OutputPath,
    [object]$Word
  )

  $readOnly = $true
  $confirmConversions = $false
  $visible = $false
  $doc = $null

  try {
    $doc = $Word.Documents.Open([ref]$InputPath, [ref]$confirmConversions, [ref]$readOnly, [ref]$false)
    $formatUnicodeText = 7
    $doc.SaveAs2([ref]$OutputPath, [ref]$formatUnicodeText)
  }
  finally {
    if ($doc -ne $null) {
      $doc.Close([ref]$false) | Out-Null
    }
  }
}

$repo = Resolve-SourceDir $SourceDir
$root = Join-Path (Get-Location).Path $OutputRoot
New-Item -ItemType Directory -Force -Path $root | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $root "corpus") | Out-Null

$commit = (Invoke-Git -Repo $repo -Arguments @("rev-parse", $Ref) | Select-Object -First 1).Trim()
$tree = Invoke-Git -Repo $repo -Arguments @("ls-tree", "-r", $Ref)
$entries = foreach ($line in $tree) {
  if ($line -match "^\d+\s+blob\s+([0-9a-f]+)\t(.+)$") {
    $path = $Matches[2]
    if ($OnlyPath.Count -gt 0 -and -not ($OnlyPath | Where-Object { $path -eq $_ -or $path.StartsWith($_.TrimEnd("/") + "/") })) {
      continue
    }
    [pscustomobject]@{
      Sha = $Matches[1]
      Path = $path
      Ext = [System.IO.Path]::GetExtension($path).ToLowerInvariant()
    }
  }
}

$directTextExt = @(".txt", ".md", ".markdown")
$wordExt = @(".pdf", ".doc", ".docx", ".rtf")
$imageExt = @(".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp", ".tif", ".tiff")
$manifest = @()
$word = $null
$wordCount = 0
$tempRoot = Join-Path $env:TEMP ("mao-selected-works-ingest-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

try {
  if ($ConvertWithWord) {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0
  }

  foreach ($entry in $entries) {
    $status = "skipped"
    $conversion = ""
    $target = ""
    $note = ""

    try {
      if ($directTextExt -contains $entry.Ext) {
        $bytes = Get-GitBlobBytes -Repo $repo -Sha $entry.Sha
        $text = Convert-BytesToText -Bytes $bytes
        $title = [System.IO.Path]::GetFileNameWithoutExtension($entry.Path)
        if ([string]::IsNullOrWhiteSpace($title)) { $title = $entry.Path }
        $target = Write-MarkdownText -Root $root -SourcePath $entry.Path -Title $title -Text $text -Conversion "direct-text" -Commit $commit -Repo $SourceRepo
        $status = "imported"
        $conversion = "direct-text"
      }
      elseif ($wordExt -contains $entry.Ext) {
        $wordPathMatches = $WordPath.Count -eq 0 -or ($WordPath | Where-Object { $entry.Path -eq $_ -or $entry.Path.StartsWith($_.TrimEnd("/") + "/") })
        if ($ConvertWithWord -and $wordPathMatches -and ($MaxWordConversions -le 0 -or $wordCount -lt $MaxWordConversions)) {
          $wordCount += 1
          $bytes = Get-GitBlobBytes -Repo $repo -Sha $entry.Sha
          $input = Join-Path $tempRoot ([guid]::NewGuid().ToString("N") + $entry.Ext)
          $txt = Join-Path $tempRoot ([guid]::NewGuid().ToString("N") + ".txt")
          [System.IO.File]::WriteAllBytes($input, $bytes)
          Convert-WithWordToText -InputPath $input -OutputPath $txt -Word $word
          $text = Get-Content -LiteralPath $txt -Raw -Encoding Unicode
          $title = [System.IO.Path]::GetFileNameWithoutExtension($entry.Path)
          $target = Write-MarkdownText -Root $root -SourcePath $entry.Path -Title $title -Text $text -Conversion "word-com-text" -Commit $commit -Repo $SourceRepo
          $status = "imported"
          $conversion = "word-com-text"
        }
        else {
          $status = "available-for-word-conversion"
          $conversion = "word-com-text"
          $note = "Run with -ConvertWithWord to convert this file through Microsoft Word."
        }
      }
      elseif ($imageExt -contains $entry.Ext) {
        $status = "skipped-image"
        $note = "Image binary is not stored in the text knowledge base."
      }
      else {
        $status = "unsupported-binary"
        $note = "Binary/e-book file is registered but not converted by this script."
      }
    }
    catch {
      $status = "failed"
      $note = $_.Exception.Message
    }

    $manifest += [pscustomobject]@{
      source_path = $entry.Path
      source_sha = $entry.Sha
      extension = $entry.Ext
      status = $status
      conversion = $conversion
      target_path = if ($target) { (Resolve-Path -LiteralPath $target).Path.Substring((Get-Location).Path.Length + 1).Replace("\", "/") } else { "" }
      note = $note
    }
  }
}
finally {
  if ($word -ne $null) {
    $word.Quit() | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
  }
  if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
  }
}

$manifestObject = [pscustomobject]@{
  source_repo = $SourceRepo
  source_commit = $commit
  generated_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
  output_root = $OutputRoot.Replace("\", "/")
  total_entries = $manifest.Count
  imported_entries = @($manifest | Where-Object { $_.status -eq "imported" }).Count
  entries = $manifest
}

$manifestPath = Join-Path $root "MANIFEST.json"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($manifestPath, ($manifestObject | ConvertTo-Json -Depth 6), $utf8NoBom)

Write-Output "source_commit=$commit"
Write-Output "total_entries=$($manifest.Count)"
Write-Output "imported_entries=$($manifestObject.imported_entries)"
Write-Output "manifest=$manifestPath"
