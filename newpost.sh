#!/bin/bash

# Define the base directory for Jekyll posts
POSTS_DIR="./docs/_posts"

# Ensure the _posts directory exists
mkdir -p "$POSTS_DIR" || { echo "Error: Could not create directory $POSTS_DIR. Check permissions."; exit 1; }

echo "--- Jekyll Post Creator ---"
echo ""

# 1. Get the post title
read -p "Enter Post Title: " POST_TITLE

if [ -z "$POST_TITLE" ]; then
    echo "Error: Post title cannot be empty. Exiting."
    exit 1
fi

# 2. Get the author (optional, but good practice for Jekyll)
read -p "Enter Author Name (optional, press Enter to skip): " POST_AUTHOR

# 3. Generate filename (YYYY-MM-DD-slug.md)
# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Convert title to a URL-friendly slug
# Lowercase, replace spaces with hyphens, remove non-alphanumeric chars (except hyphens)
POST_SLUG=$(echo "$POST_TITLE" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-*|-*$//g' | tr '[:upper:]' '[:lower:]')

if [ -z "$POST_SLUG" ]; then
    echo "Error: Could not generate a valid slug from the title. Exiting."
    exit 1
fi

FILENAME="${CURRENT_DATE}-${POST_SLUG}.md"
POST_PATH="${POSTS_DIR}/${FILENAME}"

# Check if file already exists
if [ -f "$POST_PATH" ]; then
    echo "Warning: A post with the filename '$FILENAME' already exists."
    read -p "Do you want to overwrite it? (y/N): " OVERWRITE_CHOICE
    if [[ ! "$OVERWRITE_CHOICE" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled. Post not created."
        exit 0
    fi
fi

echo ""
echo "Now enter your post content. Press Ctrl+D when you are finished."
echo "---------------------------------------------------------------"

# Read multiline content until Ctrl+D is pressed
POST_CONTENT=$(cat)

echo "---------------------------------------------------------------"
echo ""

# Construct the Jekyll front matter
FRONT_MATTER="---
layout: post
title: \"${POST_TITLE}\"
date: ${CURRENT_DATE}
"
if [ -n "$POST_AUTHOR" ]; then
    FRONT_MATTER="${FRONT_MATTER}author: \"${POST_AUTHOR}\"
"
fi
FRONT_MATTER="${FRONT_MATTER}---
"

# Combine front matter and content
FULL_POST_CONTENT="${FRONT_MATTER}

${POST_CONTENT}"

# Write to file
echo "$FULL_POST_CONTENT" > "$POST_PATH"

echo "Post '$POST_TITLE' created successfully at: $POST_PATH"
echo "You can now run 'jekyll serve' or 'jekyll build' to see your new post."