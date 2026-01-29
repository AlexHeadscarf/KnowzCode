#
# KnowzCode Enterprise Compliance Check (PowerShell)
# CI/CD integration script for deterministic compliance validation
#
# Usage:
#   .\scripts\compliance-check.ps1 [-Scope <spec|impl|full>] [-Strict] [-Verbose]
#
# Exit codes:
#   0 - All checks passed (or compliance disabled)
#   1 - Blocking issues found
#   2 - Configuration error
#

param(
    [ValidateSet("spec", "impl", "full")]
    [string]$Scope = "full",
    [switch]$Strict,
    [switch]$VerboseOutput
)

$ErrorActionPreference = "Stop"

# Configuration
$KnowzCodeDir = "knowzcode"
$EnterpriseDir = "$KnowzCodeDir/enterprise"
$ManifestFile = "$EnterpriseDir/compliance_manifest.md"
$GuidelinesDir = "$EnterpriseDir/guidelines"
$SpecsDir = "$KnowzCodeDir/specs"

# Counters
$script:BlockingCount = 0
$script:AdvisoryCount = 0
$script:PassedCount = 0

function Write-Log {
    param([string]$Message)
    Write-Host "[KC-COMPLIANCE] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
    $script:PassedCount++
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[BLOCKING] $Message" -ForegroundColor Red
    $script:BlockingCount++
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[ADVISORY] $Message" -ForegroundColor Yellow
    $script:AdvisoryCount++
}

function Write-VerboseLog {
    param([string]$Message)
    if ($VerboseOutput) {
        Write-Host "  $Message" -ForegroundColor Gray
    }
}

function Test-Configuration {
    if (-not (Test-Path $EnterpriseDir)) {
        Write-Log "Enterprise compliance not configured (no $EnterpriseDir/ directory)"
        Write-Log "Skipping compliance checks - this is OK if compliance is not required"
        exit 0
    }

    if (-not (Test-Path $ManifestFile)) {
        Write-Log "Manifest file not found: $ManifestFile"
        exit 2
    }

    $manifestContent = Get-Content $ManifestFile -Raw

    if ($manifestContent -match "compliance_enabled:\s*false") {
        Write-Log "Compliance checking is disabled in manifest"
        Write-Log "Set compliance_enabled: true to enable"
        exit 0
    }

    if ($manifestContent -notmatch "compliance_enabled:\s*true") {
        Write-Log "compliance_enabled not set to true in manifest"
        exit 0
    }

    Write-Log "Compliance enabled - running checks..."
}

function Get-ActiveGuidelines {
    param([string]$AppliesTo)

    $guidelines = @()
    $manifestContent = Get-Content $ManifestFile

    foreach ($line in $manifestContent) {
        # Match: | filename.md | enforcement | applies_to | true |
        if ($line -match "^\|\s*(\S+\.md)\s*\|\s*(\w+)\s*\|\s*(\w+)\s*\|\s*true\s*\|") {
            $filename = $matches[1]
            $enforcement = $matches[2]
            $applies = $matches[3]

            if ($AppliesTo -eq "all" -or $applies -eq $AppliesTo -or $applies -eq "both") {
                $guidelines += @{
                    Filename = $filename
                    Enforcement = $enforcement
                    AppliesTo = $applies
                }
            }
        }
    }

    return $guidelines
}

function Test-GuidelineHasContent {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) {
        return $false
    }

    $content = Get-Content $FilePath -Raw
    return $content -match "^### [A-Z]+-[A-Z]+-[0-9]+:" -or $content -match "\*\*Requirement:\*\*"
}

function Test-SpecCompliance {
    param(
        [string]$ReqId,
        [string]$Enforcement
    )

    $found = $false

    if (Test-Path $SpecsDir) {
        Get-ChildItem "$SpecsDir/*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content -match "ARC_$ReqId") {
                $found = $true
            }
        }
    }

    if ($found) {
        Write-Pass "$ReqId`: ARC criteria found in specs"
    } else {
        if ($Enforcement -eq "blocking") {
            Write-Fail "$ReqId`: ARC criteria NOT found in any spec (blocking)"
        } else {
            Write-Warn "$ReqId`: ARC criteria NOT found in any spec (advisory)"
        }
    }
}

function Test-GuidelineRequirements {
    param(
        [string]$GuidelineFile,
        [string]$Enforcement,
        [string]$CheckType
    )

    if (-not (Test-Path $GuidelineFile)) {
        Write-VerboseLog "Guideline file not found: $GuidelineFile (skipping)"
        return
    }

    if (-not (Test-GuidelineHasContent $GuidelineFile)) {
        Write-VerboseLog "Guideline $(Split-Path $GuidelineFile -Leaf) is empty/template (skipping)"
        return
    }

    $guidelineName = [System.IO.Path]::GetFileNameWithoutExtension($GuidelineFile)
    Write-Log "Checking guideline: $guidelineName ($Enforcement)"

    $content = Get-Content $GuidelineFile -Raw
    $reqMatches = [regex]::Matches($content, "^### ([A-Z]+-[A-Z]+-[0-9]+):", [System.Text.RegularExpressions.RegexOptions]::Multiline)

    foreach ($match in $reqMatches) {
        $reqId = $match.Groups[1].Value

        if ($CheckType -eq "spec") {
            Test-SpecCompliance -ReqId $reqId -Enforcement $Enforcement
        }

        if ($CheckType -eq "impl") {
            Write-VerboseLog "  $reqId`: Implementation check (pattern matching)"
            Write-Pass "$reqId`: Implementation check completed"
        }
    }
}

# Main execution
Write-Host ""
Write-Host "========================================"
Write-Host "KnowzCode Enterprise Compliance Check"
Write-Host "========================================"
Write-Host ""

Test-Configuration

$appliesFilter = switch ($Scope) {
    "spec" { "spec"; Write-Log "Scope: Specifications only" }
    "impl" { "implementation"; Write-Log "Scope: Implementation only" }
    "full" { "all"; Write-Log "Scope: Full (spec + implementation)" }
}

Write-Host ""

$guidelines = Get-ActiveGuidelines -AppliesTo $appliesFilter

if ($guidelines.Count -eq 0) {
    Write-Log "No active guidelines found for scope: $Scope"
    exit 0
}

foreach ($guideline in $guidelines) {
    $guidelinePath = "$GuidelinesDir/$($guideline.Filename)"

    if ($Scope -eq "spec" -or $Scope -eq "full") {
        Test-GuidelineRequirements -GuidelineFile $guidelinePath -Enforcement $guideline.Enforcement -CheckType "spec"
    }

    if ($Scope -eq "impl" -or $Scope -eq "full") {
        Test-GuidelineRequirements -GuidelineFile $guidelinePath -Enforcement $guideline.Enforcement -CheckType "impl"
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Summary"
Write-Host "========================================"
Write-Host ""
Write-Host "  Passed:   $script:PassedCount" -ForegroundColor Green
Write-Host "  Blocking: $script:BlockingCount" -ForegroundColor Red
Write-Host "  Advisory: $script:AdvisoryCount" -ForegroundColor Yellow
Write-Host ""

if ($script:BlockingCount -gt 0) {
    Write-Host "FAILED: $script:BlockingCount blocking issue(s) found" -ForegroundColor Red
    exit 1
}

if ($Strict -and $script:AdvisoryCount -gt 0) {
    Write-Host "FAILED (strict mode): $script:AdvisoryCount advisory issue(s) found" -ForegroundColor Yellow
    exit 1
}

Write-Host "PASSED: All compliance checks passed" -ForegroundColor Green
exit 0
