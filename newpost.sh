#!/bin/bash

# Check if at least two parameters are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <title> <content> [img_url]"
    exit 1
fi

git reset --hard HEAD
git clean -f -d
git pull

# Read the title and content from command line parameters
title="$1"
content="$2"

# Set the image URL if provided as the third parameter; otherwise, use a default URL
img_url="${3:-https://bengkulu.kemenag.go.id/file/file/Gambar/logo2.jpg}"

# Calculate yesterday's date in the format YYYY-MM-DD
current_date=$(date +%Y-%m-%d)
yesterday=$(date -d "$current_date - 1 day" +%Y-%m-%d)

# Replace spaces in the title with hyphens and convert to lowercase
title_slug=$(echo "$title" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')

# Create the filename using yesterday's date and the title
filename="${yesterday}-${title_slug}.md"

# Check if the _posts directory exists, create it if not
if [ ! -d "_posts" ]; then
    mkdir -p "_posts"
fi

# Check if the file already exists and delete it
if [ -e "_posts/$filename" ]; then
    rm "_posts/$filename"
fi

# Create the new Markdown file with a simple template
echo "---" >> "_posts/$filename"
echo "layout: post" >> "_posts/$filename"
echo "title: \"$title\"" >> "_posts/$filename"
echo "date: ${yesterday}" >> "_posts/$filename"
echo "categories: Berita" >> "_posts/$filename"
echo "img: \"$img_url\"" >> "_posts/$filename"
echo "author: Tim Humas MAN 2 Kota Bima" >> "_posts/$filename"
echo "editor: Tim Humas MAN 2 Kota Bima" >> "_posts/$filename"
echo "---" >> "_posts/$filename"

# Append the content to the file while preserving line breaks and double quotes
echo -e "$content" >> "_posts/$filename"

echo "Created _posts/$filename"

git commit add .
git commit -m post
git push

