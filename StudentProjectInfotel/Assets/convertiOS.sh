#!/bin/bash
# Downsamples all retina ...@3x.png images.

echo "Downsampling retina images..."

dir=$(pwd)
find "$dir" -name "*@3x.png" -o -name "*@3x.jpg" | while read image; do

ext="${image##*.}"
outfileRetina=$(dirname "$image")/$(basename "$image" @3x.$ext)@2x.$ext
outfileStandard=$(dirname "$image")/$(basename "$image" @3x.$ext).$ext

echo "outfile = $outfile"
if [ "$image" -nt "$outfile" ]; then
basename "$outfile"

width=$(sips -g "pixelWidth" "$image" | awk 'FNR>1 {print $2}')
height=$(sips -g "pixelHeight" "$image" | awk 'FNR>1 {print $2}')
sips -z $(($height / 2)) $(($width / 2)) "$image" --out "$outfileRetina"
test "$outfileRetina" -nt "$image" || exit 1

sips -z $(($height / 3)) $(($width / 3)) "$image" --out "$outfileStandard"
test "$outfileStandard" -nt "$image" || exit 1
fi
done