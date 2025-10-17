#!/bin/bash
#
# Script to extract and display metadata (title, authors, date) from downloaded PDFs
# Uses pdftotext to extract text from the first page and attempts to identify key information

DOWNLOAD_DIR="llm_papers_syllabus"

# Check if pdftotext is available
if ! command -v pdftotext &> /dev/null; then
    echo "Error: pdftotext is not installed. Please install poppler-utils."
    exit 1
fi

# Check if directory exists
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Error: Directory $DOWNLOAD_DIR does not exist."
    exit 1
fi

echo "Extracting metadata from PDFs in $DOWNLOAD_DIR..."
echo "========================================================"
echo ""

# Counter for papers processed
count=0

# Process each PDF in the directory
for pdf_file in "$DOWNLOAD_DIR"/*.pdf; do
    # Skip if no PDFs found
    if [ ! -f "$pdf_file" ]; then
        echo "No PDF files found in $DOWNLOAD_DIR"
        exit 0
    fi

    count=$((count + 1))
    filename=$(basename "$pdf_file")

    echo "[$count] File: $filename"
    echo "---"

    # Extract first page text (most metadata is on first page)
    # Using -l 1 to limit to first page, -layout to preserve some formatting
    text=$(pdftotext -l 1 -layout "$pdf_file" - 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "  ERROR: Could not extract text from $filename"
        echo ""
        continue
    fi

    # Extract title (usually first substantial line, often in larger font)
    # Look for the first non-empty line that's longer than 10 characters
    title=$(echo "$text" | grep -v '^[[:space:]]*$' | head -20 | grep -E '.{10,}' | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Extract potential authors
    # Common patterns: names with capitals, often after title, before abstract
    # Look for lines with multiple capital letters (likely names)
    authors=$(echo "$text" | head -30 | grep -iE '([A-Z][a-z]+[[:space:]]+){1,}[A-Z][a-z]+' | grep -iv 'abstract\|introduction\|keywords\|university' | head -5 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Extract date/year
    # Look for 4-digit years between 1990-2025, or date patterns
    year=$(echo "$text" | grep -oE '(19[9][0-9]|20[0-2][0-9])' | head -1)

    # Also look for full dates
    date_pattern=$(echo "$text" | grep -oE '(January|February|March|April|May|June|July|August|September|October|November|December)[[:space:]]+[0-9]{1,2},?[[:space:]]+[0-9]{4}' | head -1)

    # Try to find arXiv ID which often contains date info
    arxiv_id=$(echo "$text" | grep -oE 'arXiv:[0-9]{4}\.[0-9]{4,5}' | head -1)

    # Display extracted information
    echo "  Title (extracted):"
    if [ -n "$title" ]; then
        echo "    $title"
    else
        echo "    (not found)"
    fi

    echo ""
    echo "  Authors (potential matches):"
    if [ -n "$authors" ]; then
        echo "$authors" | while IFS= read -r line; do
            [ -n "$line" ] && echo "    $line"
        done
    else
        echo "    (not found)"
    fi

    echo ""
    echo "  Date information:"
    if [ -n "$date_pattern" ]; then
        echo "    Full date: $date_pattern"
    fi
    if [ -n "$year" ]; then
        echo "    Year: $year"
    fi
    if [ -n "$arxiv_id" ]; then
        echo "    arXiv ID: $arxiv_id"
    fi
    if [ -z "$date_pattern" ] && [ -z "$year" ] && [ -z "$arxiv_id" ]; then
        echo "    (not found)"
    fi

    echo ""
    echo ""
done

echo "========================================================"
echo "Processed $count PDF files."
