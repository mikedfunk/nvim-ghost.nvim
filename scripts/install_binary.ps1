echo "Preparing to download nvim-ghost binary..."

$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$version = Get-Content "$rootDir\.binary_version"
$assetName = "nvim-ghost-win64.zip"
$assetPath = "$rootDir\$assetName"
$outFile = "$rootDir\binary.exe"

if (Test-Path $assetName) {
  rm "$assetName"
}

if (Test-Path $outFile) {
  while (Test-Path $outFile) {
    try {
      rm "$outFile" -ErrorAction Stop
    }
    catch {
      & "$outFile" --kill 2>&1 >$null
	  Start-Sleep -Seconds 0.5
    }
  }
}

echo "Downloading binary..."

Invoke-WebRequest -uri "https://github.com/subnut/nvim-ghost.nvim/releases/download/$version/$assetName" -OutFile ( New-Item -Path "$assetPath" -Force )
Expand-Archive -LiteralPath "$assetPath" -DestinationPath "$rootDir"
rm "$assetPath"
