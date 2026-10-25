# Copy a new canto's raw photos into Images/pages as upright pNNN.jpg with no EXIF tag.
# Usage: .\ingest_pages.ps1 -src "Images\raw\Sarg_5" -start 119 [-flip auto|none|Rotate90FlipNone|Rotate180FlipNone|Rotate270FlipNone] [-write]
# Photos are taken in filename (= capture) order. "auto" applies each photo's EXIF orientation tag.
# Dry run by default (prints the plan). After writing, check orientation and the page numerals with montage.ps1
# and fix any odd page by re-running on that one file with an explicit -flip.
param([string]$src, [int]$start, [string]$flip = "auto", [switch]$write)
Add-Type -AssemblyName System.Drawing
$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$pg = Join-Path $root "Images\pages"
$srcDir = if ([IO.Path]::IsPathRooted($src)) { $src } else { Join-Path $root $src }
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$ep = New-Object System.Drawing.Imaging.EncoderParameters 1
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 92L
$exifMap = @{ 1 = "RotateNoneFlipNone"; 3 = "Rotate180FlipNone"; 6 = "Rotate90FlipNone"; 8 = "Rotate270FlipNone" }
$n = $start
Get-ChildItem $srcDir -Filter *.jpg | Sort-Object Name | ForEach-Object {
  $dst = Join-Path $pg ("p{0:D3}.jpg" -f $n)
  $img = [System.Drawing.Bitmap]::FromFile($_.FullName)
  $f = $flip
  if ($f -eq "auto") {
    $o = 1; if ($img.PropertyIdList -contains 0x0112) { $o = [int]$img.GetPropertyItem(0x0112).Value[0] }
    $f = $exifMap[$o]; if (-not $f) { $f = "RotateNoneFlipNone" }
  }
  if ((Test-Path $dst) -and $write) { $img.Dispose(); throw "$dst already exists; refusing to overwrite" }
  "{0} <- {1} [{2}]" -f ([IO.Path]::GetFileName($dst)), $_.Name, $f
  if ($write) {
    if ($f -ne "none") { $img.RotateFlip([System.Drawing.RotateFlipType]::$f) }
    $clean = New-Object System.Drawing.Bitmap $img.Width, $img.Height       # fresh bitmap => no EXIF
    $g = [System.Drawing.Graphics]::FromImage($clean); $g.DrawImage($img, 0, 0, $img.Width, $img.Height); $g.Dispose()
    $clean.Save($dst, $codec, $ep); $clean.Dispose()
  }
  $img.Dispose(); $n++
}
