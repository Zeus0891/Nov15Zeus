#!/usr/bin/env python3
"""
Script to generate Modules_Structure.md from ERP_Modules.md

Parses every module section in ERP_Modules.md and extracts:
- Module name (normalized to .prisma filename)
- List of models/tables defined under that module

Outputs a clean Markdown file with just module names and their models.
"""

import re
import sys
from pathlib import Path

def parse_erp_modules(file_path):
    """Parse ERP_Modules.md and extract module structure"""
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    modules = []
    
    # Split content by module headers (## module_name.prisma)
    # This regex finds module headers and captures the module name
    module_pattern = r'^##\s+([^#\n]+?)(?:\n|$)'
    sections = re.split(module_pattern, content, flags=re.MULTILINE)
    
    # sections[0] is the content before first module (header/intro)
    # sections[1] is first module name, sections[2] is its content
    # sections[3] is second module name, sections[4] is its content, etc.
    
    for i in range(1, len(sections), 2):
        if i + 1 >= len(sections):
            break
            
        module_name = sections[i].strip()
        module_content = sections[i + 1]
        
        # Extract models from the module content
        models = extract_models_from_content(module_content)
        
        if models:  # Only include modules that have models
            modules.append({
                'name': module_name,
                'models': models
            })
    
    return modules

def extract_models_from_content(content):
    """Extract model names from module content"""
    models = []
    
    # Look for table/model definitions in markdown tables
    # Pattern: | ModelName | Scope | Parent | Description |
    # We want to capture the first column (ModelName)
    
    lines = content.split('\n')
    in_table = False
    
    for line in lines:
        line = line.strip()
        
        # Skip empty lines
        if not line:
            continue
            
        # Check if we're in a table (starts with |)
        if line.startswith('|') and '|' in line[1:]:
            # Skip header separator lines (contains only |, -, and spaces)
            if re.match(r'^\|[\s\-|]+\|$', line):
                in_table = True
                continue
            
            # Skip table headers (Model, Scope, Parent, Description)
            if 'Model' in line and 'Scope' in line and 'Parent' in line:
                in_table = True
                continue
                
            if in_table:
                # Extract the first column (model name)
                parts = [part.strip() for part in line.split('|')]
                if len(parts) >= 2 and parts[1]:  # parts[0] is empty, parts[1] is model name
                    model_name = parts[1].strip()
                    # Only add if it looks like a model name (starts with uppercase)
                    if model_name and model_name[0].isupper() and not model_name in ['Model', 'Scope', 'Parent', 'Description']:
                        models.append(model_name)
        else:
            # If we hit a non-table line after being in a table, we're done with this table
            if in_table and line and not line.startswith('|'):
                in_table = False
    
    return models

def generate_modules_structure(modules, output_path):
    """Generate the Modules_Structure.md file"""
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# ERP Modules Structure\n\n")
        f.write("This file contains the complete structure of all ERP modules and their models.\n\n")
        
        for module in modules:
            f.write(f"## {module['name']}\n")
            
            for model in module['models']:
                f.write(f"{model}\n")
            
            f.write("\n")  # Empty line between modules

def main():
    """Main execution function"""
    
    # Define file paths
    input_file = Path("ERP_Modules.md")
    output_file = Path("Modules_Structure.md")
    
    # Check if input file exists
    if not input_file.exists():
        print(f"Error: {input_file} not found")
        sys.exit(1)
    
    try:
        # Parse the ERP modules
        print(f"Parsing {input_file}...")
        modules = parse_erp_modules(input_file)
        
        print(f"Found {len(modules)} modules")
        
        # Generate output file
        print(f"Generating {output_file}...")
        generate_modules_structure(modules, output_file)
        
        # Print summary
        total_models = sum(len(module['models']) for module in modules)
        print(f"✅ Successfully generated {output_file}")
        print(f"📊 Summary: {len(modules)} modules, {total_models} models total")
        
        # Show first few modules as preview
        print("\n📋 Preview (first 3 modules):")
        for i, module in enumerate(modules[:3]):
            print(f"  {module['name']} ({len(module['models'])} models)")
            
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()