param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"
$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $script:failures.Add($Message) | Out-Null
}

function Read-Json {
    param([string]$Path)
    $fullPath = Join-Path $Root $Path
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-Failure "Missing file: $Path"
        return $null
    }

    try {
        return Get-Content -Raw -Encoding UTF8 -LiteralPath $fullPath | ConvertFrom-Json
    }
    catch {
        Add-Failure "Invalid JSON in $Path`: $($_.Exception.Message)"
        return $null
    }
}

function Has-Text {
    param($Value)
    return ($null -ne $Value -and "$Value".Trim().Length -gt 0)
}

function Has-List {
    param($Value)
    return ($null -ne $Value -and @($Value).Count -gt 0)
}

$trigger = Read-Json "evals/trigger-evals.json"
$behavior = Read-Json "evals/behavior-evals.json"
$acceptance = Read-Json "evals/acceptance-results.json"
$stress = Read-Json "evals/stress-evals.json"
$stressResults = Read-Json "evals/stress-test-results.json"
$stressNames = @{}

if ($null -ne $trigger) {
    if (-not (Has-List $trigger.positive)) { Add-Failure "trigger-evals.json has no positive cases" }
    if (-not (Has-List $trigger.negative)) { Add-Failure "trigger-evals.json has no negative cases" }

    foreach ($case in @($trigger.positive)) {
        if (-not (Has-Text $case.input) -and -not (Has-Text $case.context)) {
            Add-Failure "Positive trigger case is missing input/context"
        }
        if ($null -eq $case.expected_trigger) {
            Add-Failure "Positive trigger case '$($case.input)' is missing expected_trigger"
        }
        if (-not (Has-Text $case.expected_scope)) {
            Add-Failure "Positive trigger case '$($case.input)' is missing expected_scope"
        }
    }

    foreach ($case in @($trigger.negative)) {
        if (-not (Has-Text $case.input)) { Add-Failure "Negative trigger case is missing input" }
        if ($null -eq $case.expected_trigger) {
            Add-Failure "Negative trigger case '$($case.input)' is missing expected_trigger"
        }
        if (-not (Has-Text $case.reason)) {
            Add-Failure "Negative trigger case '$($case.input)' is missing reason"
        }
    }
}

$behaviorNames = @{}
if ($null -ne $behavior) {
    if (-not (Has-List $behavior.cases)) { Add-Failure "behavior-evals.json has no cases" }
    foreach ($case in @($behavior.cases)) {
        if (-not (Has-Text $case.name)) { Add-Failure "Behavior case is missing name"; continue }
        if ($behaviorNames.ContainsKey($case.name)) { Add-Failure "Duplicate behavior case: $($case.name)" }
        $behaviorNames[$case.name] = $true
        if (-not (Has-Text $case.input)) { Add-Failure "Behavior case '$($case.name)' is missing input" }
        if (-not (Has-List $case.must_include)) { Add-Failure "Behavior case '$($case.name)' is missing must_include" }
        if ($null -eq $case.must_not_include) { Add-Failure "Behavior case '$($case.name)' is missing must_not_include" }
    }
}

if ($null -ne $acceptance) {
    if (-not (Has-List $acceptance.results)) { Add-Failure "acceptance-results.json has no results" }
    foreach ($result in @($acceptance.results)) {
        if (-not (Has-Text $result.case)) { Add-Failure "Acceptance result is missing case"; continue }
        if (-not $behaviorNames.ContainsKey($result.case)) {
            Add-Failure "Acceptance result references unknown behavior case: $($result.case)"
        }
        if ($result.status -ne "passed") {
            Add-Failure "Acceptance result is not passed: $($result.case) -> $($result.status)"
        }
        if (-not (Has-Text $result.output_sample)) {
            Add-Failure "Acceptance result '$($result.case)' is missing output_sample"
        }
    }

    foreach ($name in $behaviorNames.Keys) {
        $match = @($acceptance.results | Where-Object { $_.case -eq $name })
        if ($match.Count -eq 0) {
            Add-Failure "Behavior case has no acceptance result: $name"
        }
    }
}

if ($null -ne $stress) {
    if (-not (Has-List $stress.cases)) { Add-Failure "stress-evals.json has no cases" }
    foreach ($case in @($stress.cases)) {
        if (-not (Has-Text $case.name)) { Add-Failure "Stress case is missing name"; continue }
        if ($stressNames.ContainsKey($case.name)) { Add-Failure "Duplicate stress case: $($case.name)" }
        $stressNames[$case.name] = $true
        if (-not (Has-Text $case.type)) { Add-Failure "Stress case '$($case.name)' is missing type" }
        if (-not (Has-List $case.turns)) { Add-Failure "Stress case '$($case.name)' has no turns" }
        foreach ($turn in @($case.turns)) {
            if (-not (Has-Text $turn.input)) { Add-Failure "Stress case '$($case.name)' has a turn without input" }
        }
    }
}

if ($null -ne $stressResults) {
    if (-not (Has-List $stressResults.results)) { Add-Failure "stress-test-results.json has no results" }
    $counts = @{
        passed = 0
        watch = 0
        at_risk = 0
        failed = 0
    }
    foreach ($result in @($stressResults.results)) {
        if (-not (Has-Text $result.case)) { Add-Failure "Stress result is missing case"; continue }
        if ($stressNames.Count -gt 0 -and -not $stressNames.ContainsKey($result.case)) {
            Add-Failure "Stress result references unknown stress case: $($result.case)"
        }
        if (-not (Has-Text $result.status)) { Add-Failure "Stress result '$($result.case)' is missing status"; continue }
        if (-not $counts.ContainsKey($result.status)) {
            Add-Failure "Stress result '$($result.case)' has unknown status: $($result.status)"
            continue
        }
        $counts[$result.status]++
        if (-not (Has-Text $result.rationale)) {
            Add-Failure "Stress result '$($result.case)' is missing rationale"
        }
    }

    $summary = $stressResults.summary
    if ($null -eq $summary) {
        Add-Failure "stress-test-results.json is missing summary"
    }
    else {
        if ([int]$summary.total_cases -ne @($stressResults.results).Count) {
            Add-Failure "Stress summary total_cases does not match result count"
        }
        foreach ($key in $counts.Keys) {
            if ([int]$summary.$key -ne [int]$counts[$key]) {
                Add-Failure "Stress summary '$key' does not match results"
            }
        }
    }

    if ($stressNames.Count -gt 0) {
        foreach ($name in $stressNames.Keys) {
            $match = @($stressResults.results | Where-Object { $_.case -eq $name })
            if ($match.Count -eq 0) {
                Add-Failure "Stress case has no stress-test result: $name"
            }
        }
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/stress-test-report.md"))) {
    Add-Failure "Missing stress-test-report.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/tone-dialogue-pressure-test.md"))) {
    Add-Failure "Missing tone-dialogue-pressure-test.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/user-dialogue-full-pressure-test.md"))) {
    Add-Failure "Missing user-dialogue-full-pressure-test.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/long-session-continuity-test.md"))) {
    Add-Failure "Missing long-session-continuity-test.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/conversational-surface-test.md"))) {
    Add-Failure "Missing conversational-surface-test.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "evals/deep-longform-pressure-test.md"))) {
    Add-Failure "Missing deep-longform-pressure-test.md"
}

$selectedWorksManifest = Read-Json "references/history/selected-works-of-mao-tsetung/MANIFEST.json"
if ($null -ne $selectedWorksManifest) {
    if (-not (Has-Text $selectedWorksManifest.source_commit)) {
        Add-Failure "Selected Works manifest is missing source_commit"
    }
    if ([int]$selectedWorksManifest.imported_entries -lt 1) {
        Add-Failure "Selected Works manifest has no imported entries"
    }
    $canonical = @($selectedWorksManifest.entries | Where-Object {
        $_.source_sha -eq "93b13f6d1c214433310c1a273773d0888828efa4" -and $_.status -eq "imported"
    })
    if ($canonical.Count -ne 1) {
        Add-Failure "Selected Works manifest is missing imported canonical selected-works txt blob"
    }
    elseif (-not (Test-Path -LiteralPath (Join-Path $Root $canonical[0].target_path))) {
        Add-Failure "Missing canonical Selected Works Markdown text at manifest target_path"
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "references/history/selected-works-of-mao-tsetung/SOURCE.md"))) {
    Add-Failure "Missing Selected Works SOURCE.md"
}

if ($failures.Count -gt 0) {
    Write-Host "Eval validation failed:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host " - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Eval validation passed." -ForegroundColor Green
Write-Host "Checked trigger, behavior, acceptance, stress, and stress-result files."
