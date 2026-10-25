# Contact sheet of the top and (180-rotated) bottom margin strips of pages $from..$to, to read page numerals.
# Usage: .\montage.ps1 -from 1 -to 11 -out $env:TEMP\m.png
param([int]$from, [int]$to, [string]$out)
Add-Type -AssemblyName System.Drawing
$pages = $from..$to
$tw = 900; $th = 70
$sheet = New-Object System.Drawing.Bitmap $tw, ($th * 2 * $pages.Count)
$g = [System.Drawing.Graphics]::FromImage($sheet)
$g.Clear([System.Drawing.Color]::White)
$font = New-Object System.Drawing.Font "Arial", 20
$i = 0
foreach ($p in $pages) {
  $img = [System.Drawing.Bitmap]::FromFile((Resolve-Path (Join-Path $PSScriptRoot ("..\..\Images\pages\p{0:D3}.jpg" -f $p))))
  $W = $img.Width; $H = $img.Height
  # top strip, and bottom strip rotated 180 so an upside-down page reads upright
  $top = $img.Clone((New-Object System.Drawing.Rectangle 0, 0, $W, ([int]($H*0.07))), $img.PixelFormat)
  $bot = $img.Clone((New-Object System.Drawing.Rectangle 0, ([int]($H*0.93)), $W, ([int]($H*0.07))), $img.PixelFormat)
  $bot.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone)
  $g.DrawImage($top, 120, $i*$th*2, $tw-120, $th)
  $g.DrawImage($bot, 120, $i*$th*2+$th, $tw-120, $th)
  $g.DrawString(("p{0:D3}" -f $p), $font, [System.Drawing.Brushes]::Red, 5, $i*$th*2+40)
  $top.Dispose(); $bot.Dispose(); $img.Dispose(); $i++
}
$sheet.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
