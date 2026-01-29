# KnowzCode PowerShell Installer
# Installs KnowzCode framework without requiring Claude Code commands
#
# Usage:
#   .\install.ps1                           # Install to current directory
#   .\install.ps1 -Target C:\path\to\dir    # Install to specific directory
#   .\install.ps1 -Global                   # Install commands to ~/.claude/
#   .\install.ps1 -Force                    # Overwrite existing installation

[CmdletBinding()]
param(
    [Parameter(HelpMessage = "Target directory for installation")]
    [string]$Target = "",

    [Parameter(HelpMessage = "Install commands globally to ~/.claude/")]
    [switch]$Global,

    [Parameter(HelpMessage = "Overwrite existing installation")]
    [switch]$Force,

    [Parameter(HelpMessage = "Show help message")]
    [switch]$Help
)

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Color output functions
function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "[SUCCESS] $args" -ForegroundColor Green }
function Write-Warning { Write-Host "[WARNING] $args" -ForegroundColor Yellow }
function Write-Error { Write-Host "[ERROR] $args" -ForegroundColor Red }

# Show usage
function Show-Usage {
    @"
KnowzCode Installer

Usage:
    .\install.ps1 [OPTIONS]

Options:
    -Target <path>   Install to specific directory (default: current directory)
    -Global          Install commands to ~/.claude/ (framework files still go to target)
    -Force           Overwrite existing installation without prompting
    -Help            Show this help message

Examples:
    # Install to current directory
    .\install.ps1

    # Install to a specific project
    .\install.ps1 -Target C:\path\to\your\project

    # Global commands + local framework
    .\install.ps1 -Global -Target C:\path\to\your\project

    # Force reinstall
    .\install.ps1 -Force -Target C:\path\to\your\project

"@
}

# Validate source files exist
function Test-SourceFiles {
    Write-Info "Validating source files..."

    $knowzcodeDir = Join-Path $ScriptDir "knowzcode"
    $commandsDir = Join-Path $ScriptDir "commands"
    $agentsDir = Join-Path $ScriptDir "agents"

    if (-not (Test-Path $knowzcodeDir -PathType Container)) {
        Write-Error "Source directory 'knowzcode/' not found in $ScriptDir"
        Write-Error "Please run this script from the KnowzCode template directory."
        exit 1
    }

    if (-not (Test-Path $commandsDir -PathType Container)) {
        Write-Error "Source directory 'commands/' not found in $ScriptDir"
        Write-Error "Please run this script from the KnowzCode template directory."
        exit 1
    }

    if (-not (Test-Path $agentsDir -PathType Container)) {
        Write-Error "Source directory 'agents/' not found in $ScriptDir"
        Write-Error "Please run this script from the KnowzCode template directory."
        exit 1
    }

    Write-Success "Source files validated"
}

# Check for existing installation
function Test-ExistingInstallation {
    param([string]$ClaudeDir, [string]$KnowzcodeDir)

    $commandsDir = Join-Path $ClaudeDir "commands"
    $agentsDir = Join-Path $ClaudeDir "agents"

    $existingPaths = @()
    if (Test-Path $commandsDir) { $existingPaths += $commandsDir }
    if (Test-Path $agentsDir) { $existingPaths += $agentsDir }
    if (Test-Path $KnowzcodeDir) { $existingPaths += $KnowzcodeDir }

    if ($existingPaths.Count -gt 0) {
        if (-not $Force) {
            Write-Warning "KnowzCode appears to already be installed at:"
            $existingPaths | ForEach-Object { Write-Host "  - $_" }
            Write-Host ""
            Write-Error "Use -Force to overwrite existing installation."
            exit 1
        } else {
            Write-Warning "Overwriting existing installation (-Force specified)"
        }
    }
}

# Copy directory recursively
function Copy-DirectoryContents {
    param([string]$Source, [string]$Destination)

    if (-not (Test-Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    if (Test-Path $Source) {
        Get-ChildItem -Path $Source -Recurse | ForEach-Object {
            $destPath = $_.FullName.Replace($Source, $Destination)
            if ($_.PSIsContainer) {
                if (-not (Test-Path $destPath)) {
                    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
                }
            } else {
                $destDir = Split-Path -Parent $destPath
                if (-not (Test-Path $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                Copy-Item -Path $_.FullName -Destination $destPath -Force
            }
        }
    }
}

# Initialize tracker file
function Initialize-Tracker {
    param([string]$TrackerFile)

    $content = @'
# KnowzCode - Status Map

**Purpose:** This document tracks the development status of all implementable components (NodeIDs) defined in `knowzcode_architecture.md`.

---
**Progress: 0%**
---

| Status | WorkGroupID | Node ID | Label | Dependencies | Logical Grouping | Spec Link | Classification | Notes / Issues |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| | | | | | | | | |

---
### Status Legend:

*   ⚪️ **`[TODO]`**: Task is defined and ready to be picked up if dependencies are met.
*   📝 **`[NEEDS_SPEC]`**: Node has been identified but requires a detailed specification.
*   ◆ **`[WIP]`**: Work In Progress. The KnowzCode AI Agent is currently working on this node.
*   🟢 **`[VERIFIED]`**: Node has been implemented and verified.
*   ❗ **`[ISSUE]`**: A significant issue or blocker has been identified.

---
*(This table will be populated as you define your architecture and NodeIDs.)*
'@

    Set-Content -Path $TrackerFile -Value $content -Encoding UTF8
}

# Initialize log file
function Initialize-Log {
    param([string]$LogFile)

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $content = @"
# KnowzCode - Operational Record

**Purpose:** Chronological record of significant events, decisions, and verification outcomes.

---

## Section 1: Operational Log

---
**[NEWEST ENTRIES APPEAR HERE - DO NOT REMOVE THIS MARKER]**
---
**Type:** SystemInitialization
**Timestamp:** $timestamp
**NodeID(s):** Project-Wide
**Logged By:** install.ps1
**Details:**
KnowzCode framework installed via PowerShell installer.
- Commands and agents installed
- Framework files initialized
- Ready for first feature: run ``/kc "Your feature"``
---

## Section 2: Reference Quality Criteria (ARC-Based Verification)

### Core Quality Criteria
1.  **Maintainability:** Ease of modification, clarity of code and design.
2.  **Reliability:** Robustness of error handling, fault tolerance.
3.  **Testability:** Adequacy of unit test coverage, ease of testing.
4.  **Performance:** Responsiveness, efficiency in resource utilization.
5.  **Security:** Resistance to common vulnerabilities.

### Structural Criteria
6.  **Readability:** Code clarity, adherence to naming conventions.
7.  **Complexity Management:** Avoidance of overly complex logic.
8.  **Modularity:** Adherence to Single Responsibility Principle.
9.  **Code Duplication (DRY):** Minimization of redundant code.
10. **Standards Compliance:** Adherence to language best practices.

*(Refer to these criteria during ARC-Based Verification.)*
"@

    Set-Content -Path $LogFile -Value $content -Encoding UTF8
}

# Main installation function
function Install-KnowzCode {
    param([string]$TargetDir)

    # Determine where to install Claude commands/agents
    if ($Global) {
        $claudeTarget = Join-Path $env:USERPROFILE ".claude"
        Write-Info "Installing commands globally to $claudeTarget/"
    } else {
        $claudeTarget = Join-Path $TargetDir ".claude"
        Write-Info "Installing commands locally to $claudeTarget/"
    }

    $knowzcodeTarget = Join-Path $TargetDir "knowzcode"

    # Check for existing installation
    Test-ExistingInstallation -ClaudeDir $claudeTarget -KnowzcodeDir $knowzcodeTarget

    # Create directories
    Write-Info "Creating directories..."
    $directories = @(
        (Join-Path $claudeTarget "commands"),
        (Join-Path $claudeTarget "agents"),
        (Join-Path $knowzcodeTarget "specs"),
        (Join-Path $knowzcodeTarget "workgroups"),
        (Join-Path $knowzcodeTarget "prompts"),
        (Join-Path $knowzcodeTarget "planning")
    )

    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }

    # Copy commands and agents
    Write-Info "Installing commands..."
    Copy-DirectoryContents -Source (Join-Path $ScriptDir "commands") -Destination (Join-Path $claudeTarget "commands")

    Write-Info "Installing agents..."
    Copy-DirectoryContents -Source (Join-Path $ScriptDir "agents") -Destination (Join-Path $claudeTarget "agents")

    # Copy framework files
    Write-Info "Installing framework files..."

    # Copy core knowzcode files (not directories, and not tracker/log)
    Get-ChildItem -Path (Join-Path $ScriptDir "knowzcode") -Filter "*.md" | ForEach-Object {
        if ($_.Name -ne "knowzcode_tracker.md" -and $_.Name -ne "knowzcode_log.md") {
            Copy-Item -Path $_.FullName -Destination $knowzcodeTarget -Force
        }
    }

    # Copy prompts
    $promptsSource = Join-Path $ScriptDir "knowzcode\prompts"
    if (Test-Path $promptsSource) {
        Copy-DirectoryContents -Source $promptsSource -Destination (Join-Path $knowzcodeTarget "prompts")
    }

    # Copy planning readme if exists
    $planningReadme = Join-Path $ScriptDir "knowzcode\planning\Readme.md"
    if (Test-Path $planningReadme) {
        Copy-Item -Path $planningReadme -Destination (Join-Path $knowzcodeTarget "planning") -Force
    }

    # Copy specs readme if exists
    $specsReadme = Join-Path $ScriptDir "knowzcode\specs\Readme.md"
    if (Test-Path $specsReadme) {
        Copy-Item -Path $specsReadme -Destination (Join-Path $knowzcodeTarget "specs") -Force
    }

    # Copy workgroups readme if exists
    $workgroupsReadme = Join-Path $ScriptDir "knowzcode\workgroups\README.md"
    if (Test-Path $workgroupsReadme) {
        Copy-Item -Path $workgroupsReadme -Destination (Join-Path $knowzcodeTarget "workgroups") -Force
    }

    # Initialize fresh tracker and log
    Write-Info "Initializing tracker..."
    Initialize-Tracker -TrackerFile (Join-Path $knowzcodeTarget "knowzcode_tracker.md")

    Write-Info "Initializing log..."
    Initialize-Log -LogFile (Join-Path $knowzcodeTarget "knowzcode_log.md")

    # Print success message
    Write-Host ""
    Write-Success "KnowzCode installation complete!"
    Write-Host ""
    Write-Host "Installed to:"
    Write-Host "  Commands/Agents: $claudeTarget/"
    Write-Host "  Framework:       $knowzcodeTarget/"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Edit $knowzcodeTarget\environment_context.md"
    Write-Host "     Configure your build commands, test commands, etc."
    Write-Host ""
    Write-Host "  2. Edit $knowzcodeTarget\knowzcode_project.md"
    Write-Host "     Set your project name, standards, and priorities."
    Write-Host ""
    Write-Host "  3. Start your first feature:"
    Write-Host "     cd $TargetDir"
    Write-Host "     /kc `"Your first feature description`""
    Write-Host ""
}

# Main entry point
function Main {
    Write-Host ""
    Write-Host "========================================="
    Write-Host "  KnowzCode PowerShell Installer"
    Write-Host "========================================="
    Write-Host ""

    # Show help if requested
    if ($Help) {
        Show-Usage
        exit 0
    }

    # Determine target directory
    $TargetDir = $Target
    if ([string]::IsNullOrEmpty($TargetDir)) {
        $TargetDir = Get-Location
    }

    # Resolve to absolute path
    if (-not (Test-Path $TargetDir -PathType Container)) {
        Write-Error "Target directory does not exist: $TargetDir"
        exit 1
    }
    $TargetDir = (Resolve-Path $TargetDir).Path

    # Validate and install
    Test-SourceFiles
    Install-KnowzCode -TargetDir $TargetDir
}

# Run main
Main
