<#
.SYNOPSIS
  Update the website: drop in a new CV and/or job market paper, then
  render, commit and push in one step.

.EXAMPLE
  .\update-site.ps1 -Cv "$HOME\Downloads\CV.pdf"
  .\update-site.ps1 -Jmp "$HOME\Downloads\paper.pdf"
  .\update-site.ps1 -Cv "$HOME\Downloads\CV.pdf" -Jmp "$HOME\Downloads\paper.pdf"
  .\update-site.ps1                      # just re-render and push text edits
#>
param(
  [string]$Cv,
  [string]$Jmp,
  [string]$Message,
  [switch]$NoPush
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$changes = @()

function Copy-Asset($Source, $Dest, $Label) {
    if (-not (Test-Path $Source)) { throw "$Label not found: $Source" }
    $bytes = (Get-Item $Source).Length
    if ($bytes -lt 10kb) { throw "$Label looks too small ($bytes bytes) - is it the right file?" }
    $header = [System.IO.File]::ReadAllBytes($Source)[0..3] -join ','
    if ($header -ne '37,80,68,70') { throw "$Label is not a PDF (bad header)" }
    New-Item -ItemType Directory -Force (Split-Path $Dest) | Out-Null
    Copy-Item $Source $Dest -Force
    "{0,-16} {1,10:N0} bytes  <-  {2}" -f $Label, $bytes, (Split-Path $Source -Leaf) | Write-Host
    return $Label
}

if ($Cv)  { $changes += Copy-Asset $Cv  "files/Documents/CV.pdf"                          "CV" }
if ($Jmp) { $changes += Copy-Asset $Jmp "files/Research/Siachoque_JMP_2026.pdf" "Job market paper" }

Write-Host "`nRendering..." -ForegroundColor Cyan
quarto render
if ($LASTEXITCODE -ne 0) { throw "quarto render failed - nothing committed" }

$dirty = git status --porcelain
if (-not $dirty) { Write-Host "`nNothing changed. Done." -ForegroundColor Yellow; exit 0 }

if (-not $Message) {
    $Message = if ($changes) { "Update " + ($changes -join " and ") } else { "Update site content" }
}

git add -A
git commit -q -m $Message
Write-Host "`nCommitted: $Message" -ForegroundColor Green

if ($NoPush) { Write-Host "Not pushed (-NoPush). Run 'git push' when ready." -ForegroundColor Yellow; exit 0 }

git push -q origin main
if ($LASTEXITCODE -ne 0) { throw "push failed - commit is saved locally, resolve and push manually" }
Write-Host "Pushed. Live in ~1-2 minutes at https://juanpscampos.github.io" -ForegroundColor Green
