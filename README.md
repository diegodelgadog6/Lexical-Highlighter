# Lexical Analyzer - C++ Syntax Highlighter

## Overview
A Ruby-based lexical analyzer that reads a C++ source file (`input.txt`) and generates a syntax-highlighted HTML output file (`out.html`). The output is served via a WEBrick web server on port 5000.

## Project Structure
- `main.rb` — Core lexer logic: tokenizes C++ code using regex patterns and generates `out.html`
- `server.rb` — WEBrick HTTP server that runs the lexer and serves the resulting HTML on port 5000
- `input.txt` — Sample C++ source file used as input
- `out.html` — Generated output (created at runtime)

## Tech Stack
- **Language**: Ruby 3.2
- **Web Server**: WEBrick (gem)
- **Output Format**: HTML/CSS

## Running the App
The workflow `Start application` runs `ruby server.rb` which:
1. Runs `main.rb` to generate `out.html`
2. Starts a WEBrick server on `0.0.0.0:5000`
3. Serves the syntax-highlighted HTML at `/`
4. Re-runs the lexer and redirects to `/` on `GET /run`

## Token Categories
- Comments (green italic)
- Preprocessor directives (teal with light blue background)
- Strings (orange)
- Booleans (yellow bold)
- Data types (purple bold italic)
- Loops (gray with gray background)
- Keywords (blue bold)
- Numbers (red)
- Operators (pink bold)
