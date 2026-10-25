# Crop a region of a page scan to a PNG for close reading.
# Usage: .\crop.ps1 -page 087 -y0 0.1 -y1 0.3 [-x0 0 -x1 1] [-maxw 2000] [-tag _v1] [-rot180] [-src path] [-outdir dir]
# Fractions are of the image height/width. Output: <outdir>\p<page><tag>.png (default outdir: %TEMP%\babaji_crops).
# Images/pages/*.jpg are upright at the pixel level since 2026-10-24; -rot180 is for raw/legacy files.
param([string]$page, [double]$y0 = 0, [double]$y1 = 1, [double]$x0 = 0, [double]$x1 = 1, [int]$maxw = 1600,
      [string]$tag = "", [switch]$rot180, [string]$src = "", [string]$outdir = "$env:TEMP\babaji_crops")
Add-Type -AssemblyName System.Drawing
if (-not $src) { $src = Join-Path $PSScriptRoot "..\..\Images\pages\p$page.jpg" }
New-Item -ItemType Directory -Force $outdir | Out-Null
$img = [System.Drawing.Bitmap]::FromFile((Resolve-Path $src))
if ($rot180) { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
$W = $img.Width; $H = $img.Height
$rect = New-Object System.Drawing.Rectangle ([int]($x0*$W)), ([int]($y0*$H)), ([int](($x1-$x0)*$W)), ([int](($y1-$y0)*$H))
$c = $img.Clone($rect, $img.PixelFormat)
$scale = [Math]::Min(1.0, $maxw / $c.Width)
$out = New-Object System.Drawing.Bitmap ([int]($c.Width*$scale)), ([int]($c.Height*$scale))
$g = [System.Drawing.Graphics]::FromImage($out)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($c, 0, 0, $out.Width, $out.Height)
$dst = Join-Path $outdir ("p" + $page + $tag + ".png")
$out.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
"$W x $H -> $dst"
$g.Dispose(); $out.Dispose(); $c.Dispose(); $img.Dispose()
