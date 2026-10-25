# ONE-OFF (run 2026-10-24 by Claude; kept for the record; do not re-run).
# Realigns the canto-1 page images in Images/pages so that pNNN.jpg shows manuscript page NNN,
# upright at the pixel level, with no EXIF orientation tag. Before this:
#   - p001-p011, p013-p030 were stored upside down (pixel level);
#   - p013..p027 showed manuscript pages 14..28 (shifted by one); page 13 was never photographed;
#   - p028.jpg and p030.jpg were overflow sheets (notes tails of v57 and v59), not pages;
#   - page 30 (vv. 59-60) existed only in Images/raw/Sarg_1 and was not in Images/pages.
# The originals are snapshotted in Images/pages_superseded_2026-10-24/.
Add-Type -AssemblyName System.Drawing
$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$pg = Join-Path $root "Images\pages"; $raw = Join-Path $root "Images\raw\Sarg_1"
$snap = Join-Path $root "Images\pages_superseded_2026-10-24"
New-Item -ItemType Directory -Force $snap | Out-Null
1..32 | ForEach-Object { $f = Join-Path $pg ("p{0:D3}.jpg" -f $_); if (Test-Path $f) { Copy-Item $f $snap -Force } }

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$ep = New-Object System.Drawing.Imaging.EncoderParameters 1
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 92L

function Write-Upright($srcPath, $dstPath, $flip) {
  $img = [System.Drawing.Bitmap]::FromFile($srcPath)
  if ($flip -ne "none") { $img.RotateFlip([System.Drawing.RotateFlipType]::$flip) }
  $clean = New-Object System.Drawing.Bitmap $img.Width, $img.Height     # fresh bitmap => no EXIF
  $g = [System.Drawing.Graphics]::FromImage($clean); $g.DrawImage($img, 0, 0, $img.Width, $img.Height); $g.Dispose()
  $img.Dispose()
  $tmp = "$dstPath.tmp.jpg"; $clean.Save($tmp, $codec, $ep); $clean.Dispose()
  Move-Item -Force $tmp $dstPath
  "$([IO.Path]::GetFileName($dstPath)) <- $([IO.Path]::GetFileName($srcPath)) [$flip]"
}

$S = { param($n) Join-Path $snap ("p{0:D3}.jpg" -f $n) }
$D = { param($name) Join-Path $pg $name }
1..11  | ForEach-Object { Write-Upright (& $S $_) (& $D ("p{0:D3}.jpg" -f $_)) "Rotate180FlipNone" }
Write-Upright (& $S 12) (& $D "p012.jpg") "none"
14..28 | ForEach-Object { Write-Upright (& $S ($_ - 1)) (& $D ("p{0:D3}.jpg" -f $_)) "Rotate180FlipNone" }
Remove-Item (& $D "p013.jpg")                                    # page 13 was never photographed
Write-Upright (& $S 29) (& $D "p029.jpg") "Rotate180FlipNone"
Write-Upright (& $S 28) (& $D "p029_overflow.jpg") "Rotate180FlipNone"            # back of p.28: v57 notes tail
Write-Upright (Join-Path $raw "p031_20260811_172019_page_30.jpg") (& $D "p030.jpg") "Rotate90FlipNone"
Write-Upright (& $S 30) (& $D "p030_overflow_a.jpg") "Rotate180FlipNone"          # back of p.29: v59 notes tail
Write-Upright (Join-Path $raw "p032_20260811_172030_page_30_2.jpg") (& $D "p030_overflow_b.jpg") "Rotate90FlipNone"  # back of p.30: v60 notes tail
Write-Upright (& $S 31) (& $D "p031.jpg") "none"
Write-Upright (& $S 32) (& $D "p032.jpg") "none"
