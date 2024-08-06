#!/bin/bash

# Function to get file size in bytes
get_file_size() {
    local file="$1"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        stat -c%s "$file"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        stat -f%z "$file"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Function to compress an image to be under 1 MB
compress_image() {
    local input_file="$1"
    local output_file="$2"
    local quality=85
    local max_size=1048576  # 1 MB in bytes

    # Reduce the quality iteratively until the file size is under 1 MB
    while : ; do
        magick "$input_file" -quality "$quality" "$output_file"
        local file_size
        file_size=$(get_file_size "$output_file")
        if [ "$file_size" -le "$max_size" ] || [ "$quality" -le 10 ]; then
            break
        fi
        quality=$((quality - 5))
    done

    # Provide feedback
    if [ "$file_size" -le "$max_size" ]; then
        echo "Compressed $input_file to $output_file with quality $quality (size: $file_size bytes)"
    else
        echo "Could not compress $input_file to under 1 MB. Final size: $file_size bytes"
    fi
}

# Function to convert an image to WebP format
convert_to_webp() {
    local input_file="$1"
    local output_file="${input_file%.*}.webp"
    cwebp -q 80 "$input_file" -o "$output_file"
    echo "Converted $input_file to $output_file"
}

# Check if a directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

input_directory="$1"

# Process each PNG and JPEG file in the specified directory
for img in "$input_directory"/*.png "$input_directory"/*.jpg; do
    if [ -f "$img" ]; then
        output="${img%.*}.jpg"
        if compress_image "$img" "$output"; then
            convert_to_webp "$output"
        else
            echo "Error! Could not process file $img"
        fi
    fi
done
