#!/bin/bash

# Define the output directory.
output_directory='Docs'

# Recreate the output directory if it already exists.
rm -rf $output_directory
mkdir $output_directory

# Define the target to generate documentation for.
target='DocCMiddleware'

# Define the hosting base path.
# If this is not defined, no hosting base path will be used.
hosting_base_path=$1

# Define a function for generating a .doccarchive.
generate_archive() {
    target=$1

    echo "Generating archive for ${target} in ${output_directory}..."

    # If we have defined a hosting base path, use it.
    if [ ! -z $hosting_base_path ]; then
        swift package --allow-writing-to-directory $output_directory \
            generate-documentation \
            --output-path "${output_directory}/${target}.doccarchive" \
            --target $target \
            --hosting-base-path $hosting_base_path
    else
        swift package --allow-writing-to-directory $output_directory \
            generate-documentation \
            --output-path "${output_directory}/${target}.doccarchive" \
            --target $target
    fi
}

generate_archive $target
