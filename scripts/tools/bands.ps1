# Cut a page scan into four overlapping horizontal bands (_b0.._b3), each ~2000 px wide, for reading.
# Usage: .\bands.ps1 -page 87 [-rot180] [-src path] [-outdir dir]
param([int]$page, [switch]$rot180, [string]$src = "", [string]$outdir = "$env:TEMP\babaji_crops")
$s = Join-Path $PSScriptRoot "crop.ps1"
$p = "{0:D3}" -f $page
$ys = @(@(0.0, 0.27), @(0.24, 0.51), @(0.48, 0.75), @(0.72, 1.0))
$i = 0
foreach ($b in $ys) {
  & $s -page $p -y0 ([double]$b[0]) -y1 ([double]$b[1]) -x0 0.04 -x1 0.97 -maxw 2000 -tag ("_b" + $i) -rot180:$rot180 -src $src -outdir $outdir | Out-Null
  $i++
}
"bands for p$p in $outdir"
