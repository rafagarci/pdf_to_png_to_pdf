#!/usr/bin/bash
file_name=$1
file_path=$(realpath "$file_name")

# Make directory for png images
tmp_png_dir_name="tmp_png"
if [ -d "$tmp_png_dir_name" ]
then
	# Remove everything in the directory
	# if it exists already
	rm -rf "$tmp_png_dir_name"/*
else
	# Create directory if it doesn't exist
	mkdir "$tmp_png_dir_name"
fi

# Generate PNGs from the PDF
cd $tmp_png_dir_name
pdftoppm -png "$file_path" output

# Combine files into the new PDF
convert $(ls | sort | xargs) result.pdf

# Remove PDF's metadata
exiftool -all= result.pdf &> /dev/null

# Linearize https://superuser.com/questions/1482619/how-to-prevent-recovering-metadata-when-using-exiftool
qpdf --linearize --replace-input result.pdf

# Move result into the upper directory and change it's name
mv result.pdf ..
cd ..
mv result.pdf "${file_name%.pdf}"_png.pdf

# Remove temporary directory
rm -r $tmp_png_dir_name
