#!/bin/sh

directory="$1"

convert=`which convert`
gs=`which gs`

function is_missing() {
    [[ ! -f "$1" || -z "$1" ]]
}

if is_missing "$convert" || is_missing "$gs"; then
    echo "WARNING: Skipping Icon versioning, you need to install ImageMagick and ghostscript (fonts) first, you can use brew to simplify process:"

    if is_missing "$convert"; then
        echo "brew install imagemagick"
    fi

    if is_missing "$gs"; then
        echo "brew install ghostscript"
    fi

    exit 0
fi


version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`
build=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`


function process_image() {
    local file="$1"

    echo "Overlaying ${file}"

    convert \
        -background '#0008' \
        -fill white \
        -gravity center \
        -size ${width}x40 \
        caption:"${version}\n${build}" \
        "$file" \
        +swap \
        -gravity south \
        -composite  "$file"
}

for file in `find "$directory" -name "*.png" -type f`; do
    process_image "$file"
done
