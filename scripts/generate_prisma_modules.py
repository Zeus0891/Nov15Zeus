#!/usr/bin/env python3
"""
Script to generate individual Prisma module files from Modules_Structure.md and models.generated.prisma

This script:
1. Reads the module structure from Modules_Structure.md
2. Extracts model definitions from models.generated.prisma
3. Creates individual .prisma files for each module in prisma/schemas/
4. Each module file contains only the models listed in Modules_Structure.md

The script is fully dynamic and does not hard-code any module or model names.
"""

import re
import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple

def parse_modules_structure(file_path: Path) -> Dict[str, List[str]]:
    """Parse Modules_Structure.md and return module -> models mapping"""
    
    modules = {}
    current_module = None
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            
            # Skip empty lines
            if not line:
                continue
            
            # Skip the main header
            if line.startswith('# ') or line.startswith('This file contains'):
                continue
            
            # Check if this is a module header (starts with ##)
            if line.startswith('## ') and line.endswith('.prisma'):
                current_module = line[3:]  # Remove "## " prefix
                modules[current_module] = []
                print(f"  Found module: {current_module}")
            elif current_module and not line.startswith('#'):
                # This is a model name
                modules[current_module].append(line)
    
    return modules

def extract_model_definitions(prisma_file: Path) -> Dict[str, str]:
    """Extract all model definitions from the generated prisma file"""
    
    with open(prisma_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    models = {}
    
    # Find all model definitions using regex
    # Pattern: model ModelName { ... }
    # We need to handle nested braces correctly
    
    model_pattern = r'model\s+(\w+)\s*\{'
    matches = re.finditer(model_pattern, content)
    
    for match in matches:
        model_name = match.group(1)
        start_pos = match.start()
        
        # Find the matching closing brace
        brace_count = 0
        pos = match.end() - 1  # Start at the opening brace
        
        while pos < len(content):
            if content[pos] == '{':
                brace_count += 1
            elif content[pos] == '}':
                brace_count -= 1
                if brace_count == 0:
                    # Found the closing brace
                    end_pos = pos + 1
                    model_def = content[start_pos:end_pos]
                    models[model_name] = model_def
                    break
            pos += 1
    
    return models

def generate_module_file(module_name: str, model_names: List[str], model_definitions: Dict[str, str], output_dir: Path):
    """Generate a single Prisma module file"""
    
    output_file = output_dir / module_name
    
    # Create the file content
    content_lines = [
        "// This file is auto-generated. Do not edit manually.",
        f"// Module: {module_name}",
        f"// Generated from Modules_Structure.md and models.generated.prisma",
        "",
    ]
    
    # Add model definitions in the order specified in Modules_Structure.md
    missing_models = []
    
    for model_name in model_names:
        if model_name in model_definitions:
            content_lines.append(model_definitions[model_name])
            content_lines.append("")  # Empty line between models
        else:
            missing_models.append(model_name)
    
    # Write the file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content_lines))
    
    return missing_models

def main():
    """Main execution function"""
    
    # Define file paths
    modules_structure_file = Path("Modules_Structure.md")
    generated_prisma_file = Path("prisma/schemas/generated/models.generated.prisma")
    output_dir = Path("prisma/schemas")
    
    # Check if input files exist
    if not modules_structure_file.exists():
        print(f"❌ Error: {modules_structure_file} not found")
        sys.exit(1)
    
    if not generated_prisma_file.exists():
        print(f"❌ Error: {generated_prisma_file} not found")
        sys.exit(1)
    
    # Create output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        print("📋 Parsing Modules_Structure.md...")
        modules = parse_modules_structure(modules_structure_file)
        print(f"Found {len(modules)} modules")
        
        print("🔍 Extracting model definitions from models.generated.prisma...")
        model_definitions = extract_model_definitions(generated_prisma_file)
        print(f"Extracted {len(model_definitions)} model definitions")
        
        print("📁 Generating individual module files...")
        
        total_models_processed = 0
        all_missing_models = []
        
        for module_name, model_names in modules.items():
            print(f"  Generating {module_name} ({len(model_names)} models)...")
            
            missing_models = generate_module_file(
                module_name, 
                model_names, 
                model_definitions, 
                output_dir
            )
            
            total_models_processed += len(model_names) - len(missing_models)
            all_missing_models.extend([(module_name, model) for model in missing_models])
        
        # Print summary
        print(f"\n✅ Successfully generated {len(modules)} module files")
        print(f"📊 Summary: {total_models_processed} models processed")
        print(f"📂 Output directory: {output_dir}")
        
        # Report missing models if any
        if all_missing_models:
            print(f"\n⚠️  Warning: {len(all_missing_models)} models not found in generated file:")
            for module_name, model_name in all_missing_models:
                print(f"  - {model_name} (in {module_name})")
        
        # Show sample of generated files
        print(f"\n📋 Generated files preview:")
        generated_files = list(output_dir.glob("*.prisma"))
        for i, file_path in enumerate(sorted(generated_files)[:5]):
            with open(file_path, 'r') as f:
                lines = f.readlines()
                model_count = sum(1 for line in lines if line.strip().startswith('model '))
            print(f"  {file_path.name} ({model_count} models)")
        
        if len(generated_files) > 5:
            print(f"  ... and {len(generated_files) - 5} more files")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()