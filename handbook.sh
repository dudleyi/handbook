#!/bin/sh

###############################
# D's FreeBSD Handbook (DFBH)
# Description: This small script allows you to read the FreeBSD Handbook within a terminal. Install the FreeBSD Documentation usind bsdconfig first, and then you're good to go.
# Author: Dudley I.
# Contact: dudleyi@yahoo.com
# Created: 2024-12-21
# Version: 0.0.1alpha
# License: BSD 3-Clause License
# URL: https://github.com/dudleyi/handbook
###############################

DOCS_PATH="/usr/local/share/doc/freebsd/"

# Ensure the documentation path exists
if [ ! -d "$DOCS_PATH" ]; then
  echo "Documentation directory $DOCS_PATH not found."
  exit 1
fi

# Function to display a menu of files and directories
display_menu() {
  local current_path="$1"
  clear
  echo "Browsing: $current_path"
  echo "========================================"
  echo "Enter a number to open, 'b' to go back, or 'q' to quit."
  echo "========================================"

  # Add a "Go Back" option if not at the root documentation path
  local i=1
  if [ "$current_path" != "$DOCS_PATH" ]; then
    echo "[b] 🔙 Go Back"
  fi

  # List directories and files with a numeric menu
  for item in "$current_path"/*; do
    if [ -d "$item" ]; then
      echo "[$i] 📁 $(basename "$item")"
    elif [ -f "$item" ]; then
      echo "[$i] 📄 $(basename "$item")"
    fi
    i=$((i + 1))
  done
}


view_file() {
  local file_path="$1"
  clear
  echo "Viewing: $file_path"
  echo "========================================"

  # Convert HTML to Markdown and pipe it into less
  awk '
    BEGIN { RS = ""; }
    # Remove <nav>, <script>, <style> tags and their content
    { gsub(/<nav[^>]*>.*?<\/nav>/, ""); }
    { gsub(/<script[^>]*>.*?<\/script>/, ""); }
    { gsub(/<style[^>]*>.*?<\/style>/, ""); }
    # Convert headings
    { gsub(/<h1>/, "# "); gsub(/<\/h1>/, "\n"); }
    { gsub(/<h2>/, "## "); gsub(/<\/h2>/, "\n"); }
    { gsub(/<h3>/, "### "); gsub(/<\/h3>/, "\n"); }
    { gsub(/<h4>/, "#### "); gsub(/<\/h4>/, "\n"); }
    { gsub(/<h5>/, "##### "); gsub(/<\/h5>/, "\n"); }
    { gsub(/<h6>/, "###### "); gsub(/<\/h6>/, "\n"); }
    # Convert paragraphs
    { gsub(/<p>/, "\n"); gsub(/<\/p>/, "\n"); }
    # Convert unordered lists
    { gsub(/<ul>/, "\n"); gsub(/<\/ul>/, "\n"); }
    { gsub(/<li>/, "- "); gsub(/<\/li>/, "\n"); }
    # Convert ordered lists
    { gsub(/<ol>/, "\n"); gsub(/<\/ol>/, "\n"); }
    { gsub(/<li>/, "- "); gsub(/<\/li>/, "\n"); }
    # Convert bold and italic text
    { gsub(/<b>/, "**"); gsub(/<\/b>/, "**"); }
    { gsub(/<strong>/, "**"); gsub(/<\/strong>/, "**"); }
    { gsub(/<i>/, "*"); gsub(/<\/i>/, "*"); }
    { gsub(/<em>/, "*"); gsub(/<\/em>/, "*"); }
    # Preserve code and pre tags
    { gsub(/<code>/, "`"); gsub(/<\/code>/, "`"); }
    { gsub(/<pre>/, "```\n"); gsub(/<\/pre>/, "\n```"); }
    # Keep navigation and structural tags, but remove their opening/closing tags
    { gsub(/<\/?nav>/, ""); gsub(/<\/?div>/, ""); gsub(/<\/?section>/, ""); }
    # Remove any remaining stray tags but leave their content intact
    { gsub(/<[^>]+>/, ""); }
    # Print the converted Markdown
    { print $0; }
  ' "$file_path" | less
}



# Main navigation function
navigate() {
  local current_path="$DOCS_PATH"
  while true; do
    display_menu "$current_path"

    # Read user input
    echo
    echo -n "Enter your choice (or 'q' to quit): "
    read -r choice

    # Quit the program
    if [ "$choice" = "q" ]; then
      break
    fi

    # Go back to the parent directory
    if [ "$choice" = "b" ] && [ "$current_path" != "$DOCS_PATH" ]; then
      current_path=$(dirname "$current_path")
      continue
    fi

    # Navigate to the selected item
    selected_item=$(ls "$current_path" | sed -n "${choice}p")
    selected_path="$current_path/$selected_item"

    if [ -d "$selected_path" ]; then
      current_path="$selected_path"
    elif [ -f "$selected_path" ]; then
      # Convert and display the file content
      view_file "$selected_path"
    else
      echo "Invalid choice. Please try again."
      sleep 2
    fi
  done
}


# Start the navigation
navigate
