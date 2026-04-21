# Lexical Analyzer - C++ Syntax Highlighter
# Implementation Language: Ruby

input = File.read("input.txt")

# HTML-escape function
def html_escape(text)
  text.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
end

# Define lexical categories with their regex and styles
categories = [
  { name: "comment",      regex: /\/\/[^\n]*|\/\*[\s\S]*?\*\//,                                   style: "color:#2e7d32; font-style:italic;" },
  { name: "preprocessor", regex: /#\s*(include|define|ifdef|ifndef|endif|pragma|if|else|elif|undef|error)\b[^\n]*/,  style: "color:#00838f; background-color:#e0f7fa;" },
  { name: "string",       regex: /"([^"\\]|\\.)*"|'([^'\\]|\\.)*'/,                               style: "color:#e65100;" },
  { name: "boolean",      regex: /\b(true|false)\b/,                                              style: "color:#f9a825; font-weight:bold;" },
  { name: "datatype",     regex: /\b(int|float|double|char|long|short|unsigned|signed|bool|string|wchar_t|size_t|_Bool)\b/, style: "color:#6a1b9a; font-weight:bold; font-style:italic;" },
  { name: "loop",         regex: /\b(for|while|do)\b/,                                            style: "color:#757575; background-color:#eeeeee;" },
  { name: "keyword",      regex: /\b(auto|break|case|const|continue|default|else|enum|extern|goto|if|inline|friend|namespace|class|template|try|catch|throw|new|delete|using|virtual|public|private|protected|operator|this|register|return|sizeof|static|struct|switch|typedef|union|void|volatile|cout|cin|endl|printf|scanf|main)\b/, style: "color:#1565c0; font-weight:bold;" },
  { name: "number",       regex: /\b0[xX][0-9a-fA-F]+\b|\b0[0-7]+\b|\b[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?\b/, style: "color:#b71c1c;" },
  { name: "operator",     regex: /\+\+|--|<<|>>|&&|\|\||[+\-*\/%]=?|[!=<>]=|[&|^~=]/,            style: "color:#c2185b; font-weight:bold;" },
]

# Build one combined regex with named groups
combined = Regexp.new(
  categories.map.with_index { |cat, i| "(?<g#{i}>#{cat[:regex].source})" }.join("|")
)

# Process: scan and replace matches
output = ""
pos = 0

input.scan(combined) do
  match = Regexp.last_match
  # Add text before match (unmatched text)
  if match.begin(0) > pos
    output += html_escape(input[pos...match.begin(0)])
  end

  # Find which group matched
  matched_text = match[0]
  categories.each_with_index do |cat, i|
    if match["g#{i}"]
      output += "<span style=\"#{cat[:style]}\">#{html_escape(matched_text)}</span>"
      break
    end
  end

  pos = match.end(0)
end

# Add remaining text after last match
output += html_escape(input[pos..]) if pos < input.length

# Generate HTML file
html = <<~HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lexical Analyzer Output</title>
    <style>
        body {
            background-color: #1e1e1e;
            color: #d4d4d4;
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 14px;
            padding: 30px;
        }
        pre {
            background-color: #252526;
            border: 1px solid #3c3c3c;
            border-radius: 8px;
            padding: 20px;
            overflow-x: auto;
            line-height: 1.6;
        }
        h1 {
            color: #ffffff;
            font-size: 18px;
            margin-bottom: 5px;
        }
        .legend {
            margin-bottom: 20px;
            font-size: 12px;
            color: #888;
        }
        .legend span {
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <h1>C++ Syntax Highlighter - Lexical Analyzer</h1>
    <div class="legend">
        <span style="color:#2e7d32;">&#9608; Comments</span>
        <span style="color:#1565c0;">&#9608; Keywords</span>
        <span style="color:#6a1b9a;">&#9608; Data Types</span>
        <span style="color:#e65100;">&#9608; Strings</span>
        <span style="color:#b71c1c;">&#9608; Numbers</span>
        <span style="color:#f9a825;">&#9608; Booleans</span>
        <span style="color:#c2185b;">&#9608; Operators</span>
        <span style="color:#00838f;">&#9608; Preprocessor</span>
        <span style="color:#757575;">&#9608; Loops</span>
    </div>
    <pre>#{output}</pre>
</body>
</html>
HTML

File.write(File.join(__dir__, "out.html"), html)
puts "out.html generado exitosamente!"