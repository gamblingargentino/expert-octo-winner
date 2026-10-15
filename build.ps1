# Rebuild the place file from scratch. Safe to run any time — the place file is
# generated, not authored, until Dev A starts adding geometry in Studio.
# Once geometry exists in HuntOrDie.rbxl, DO NOT run this: it would overwrite it.
param([switch]$Force)

if ((Test-Path "place\HuntOrDie.rbxl") -and -not $Force) {
	Write-Host "place\HuntOrDie.rbxl already exists." -ForegroundColor Yellow
	Write-Host "If it contains world geometry, rebuilding would destroy it."
	Write-Host "Use 'rojo serve' to sync code instead, or -Force if you are sure."
	exit 1
}

rojo build -o place\HuntOrDie.rbxl
