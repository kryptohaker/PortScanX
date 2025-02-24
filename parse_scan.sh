#!/bin/bash

# Ensure correct usage
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <file_path> <title> <output_csv>"
    exit 1
fi

FILE_PATH="$1"
TITLE="$2"
OUTPUT_CSV="$3"

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found!"
    exit 1
fi

# Append title and headers if the file is new
if [ ! -f "$OUTPUT_CSV" ]; then
    echo "Title" > "$OUTPUT_CSV"
    echo "$TITLE" >> "$OUTPUT_CSV"
    echo "PORT,STATE,SERVICE,VERSION" >> "$OUTPUT_CSV"
else
    echo "Title" >> "$OUTPUT_CSV"
    echo "$TITLE" >> "$OUTPUT_CSV"
fi

# Extract relevant data
grep "tcp" "$FILE_PATH" | awk '
{
    port=$1;
    state=$2;
    service=$3;
    version="";
    
    for(i=4; i<=NF; i++) {
        version = version $i " ";
    }

    # Trim leading/trailing spaces
    gsub(/^ *| *$/, "", version);

    # If version is empty, set it to "N/A"
    if (version == "") {
        version="N/A";
    }

    # Print in CSV format
    print port "," state "," service "," version;
}' >> "$OUTPUT_CSV"

echo "Results appended to $OUTPUT_CSV"
