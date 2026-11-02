# Cut blind second-opinion crops (whole shlok blocks, no reading attached) from a spec CSV.
# Usage: .\second_opinion_crops.ps1 -spec second_opinion\canto5\spec.csv [-sheet contact.png]
# spec columns: id,page,verse,padas,y0,y1 (fractions of image height). Output: <spec dir>\NN_pPPP_vV.jpg
param([string]$spec, [string]$sheet = "")
Add-Type -AssemblyName System.Drawing
$dir = Split-Path (Resolve-Path $spec)
$rows = Import-Csv $spec
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | ? { $_.MimeType -eq "image/jpeg" }
$ep = New-Object System.Drawing.Imaging.EncoderParameters 1
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 90L
$outs = @()
foreach ($r in $rows) {
  $img = [System.Drawing.Bitmap]::FromFile((Resolve-Path (Join-Path $PSScriptRoot ("..\..\Images\pages\p{0:D3}.jpg" -f [int]$r.page))))
  $W = $img.Width; $H = $img.Height
  $rect = New-Object System.Drawing.Rectangle ([int](0.04*$W)), ([int]([double]$r.y0*$H)), ([int](0.93*$W)), ([int](([double]$r.y1-[double]$r.y0)*$H))
  $c = $img.Clone($rect, $img.PixelFormat)
  $f = Join-Path $dir ("{0}_p{1}_v{2}.jpg" -f $r.id, $r.page, $r.verse)
  $c.Save($f, $codec, $ep); $outs += $f
  $c.Dispose(); $img.Dispose()
}
if ($sheet) {
  $tw = 700; $th = 115; $cols = 2; $n = $outs.Count; $nr = [Math]::Ceiling($n / $cols)
  $s = New-Object System.Drawing.Bitmap ($tw*$cols), ($th*$nr)
  $g = [System.Drawing.Graphics]::FromImage($s); $g.Clear([System.Drawing.Color]::White)
  $font = New-Object System.Drawing.Font "Arial", 11
  for ($i = 0; $i -lt $n; $i++) {
    $im = [System.Drawing.Bitmap]::FromFile($outs[$i])
    $x = ($i % $cols) * $tw; $y = [Math]::Floor($i / $cols) * $th
    $g.DrawImage($im, $x, $y, $tw - 4, $th - 4)
    $g.DrawString((Split-Path $outs[$i] -Leaf), $font, [System.Drawing.Brushes]::Red, $x + 2, $y + 2)
    $im.Dispose()
  }
  $s.Save($sheet, [System.Drawing.Imaging.ImageFormat]::Png)
}
"$($outs.Count) crops in $dir"
