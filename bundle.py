import os

# Folders you absolutely want to ignore
IGNORE_DIRS = {
    'node_modules', '.git', '.dart_tool', 'build', 
    'ios', 'android', 'windows', 'macos', 'linux', 
    '.idea', '.vscode', 'assets', 'outputs'
}

# Only pull the actual code files you wrote (feel free to add or remove extensions)
VALID_EXTENSIONS = {'.dart', '.py', '.js', '.ts', '.jsx', '.tsx', '.json', '.yaml'}

output_file = "project_source_bundle.md"

with open(output_file, "w", encoding="utf-8") as outfile:
    for root, dirs, files in os.walk("."):
        # Modifies dirs in-place to skip ignored folders
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        
        for file in files:
            ext = os.path.splitext(file)[1]
            if ext in VALID_EXTENSIONS:
                relative_path = os.path.relpath(os.path.join(root, file), ".")
                
                # Write file header
                outfile.write(f"\n### File: {relative_path}\n")
                # Wrap code in markdown block using the extension name as language hint
                outfile.write(f"```{ext[1:]}\n")
                
                try:
                    with open(os.path.join(root, file), "r", encoding="utf-8") as infile:
                        outfile.write(infile.read())
                except Exception as e:
                    outfile.write(f"// Error reading file: {str(e)}\n")
                
                outfile.write("\n```\n")
                outfile.write("\n" + "-"*40 + "\n")

print(f"Success! Core code bundled into {output_file}")