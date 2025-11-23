#!/usr/bin/env python3
"""
Script to extract all models with scope "Global" from ERP_Modules.md
"""

import re
import sys
from pathlib import Path

def extract_global_models(file_path):
    """Extract all models with scope 'Global' from the ERP modules file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except FileNotFoundError:
        print(f"Error: File {file_path} not found")
        return []
    except Exception as e:
        print(f"Error reading file: {e}")
        return []

    global_models = []
    current_module = None

    # Split content into lines for processing
    lines = content.split('\n')

    for i, line in enumerate(lines):
        # Check if this is a module header (prisma file)
        if line.strip().endswith('.prisma'):
            current_module = line.strip().replace('## ', '').replace('.prisma', '')
            continue

        # Look for table rows that contain model information
        if '|' in line and 'Global' in line:
            # Parse the table row
            parts = [part.strip() for part in line.split('|')]
            if len(parts) >= 4:  # Ensure we have enough columns
                model_name = parts[1].strip()
                scope = parts[2].strip()

                if scope == 'Global' and model_name and model_name != 'Model':
                    global_models.append({
                        'module': current_module,
                        'model': model_name,
                        'scope': scope,
                        'description': parts[4].strip() if len(parts) > 4 else ''
                    })

    return global_models

def print_global_models(models):
    """Print the global models in a formatted way"""
    if not models:
        print("No models with scope 'Global' found.")
        return

    print(f"\n🌍 MODELS WITH SCOPE 'GLOBAL' ({len(models)} total)")
    print("=" * 60)

    # Group by module
    modules = {}
    for model in models:
        module = model['module']
        if module not in modules:
            modules[module] = []
        modules[module].append(model)

    # Print by module
    for module, model_list in modules.items():
        print(f"\n📋 {module}.prisma ({len(model_list)} models)")
        print("-" * 40)
        for model in model_list:
            print(f"  • {model['model']}")
            if model['description']:
                # Truncate long descriptions
                desc = model['description']
                if len(desc) > 100:
                    desc = desc[:100] + "..."
                print(f"    └─ {desc}")

    # Summary
    print(f"\n📊 SUMMARY")
    print(f"Total Global models: {len(models)}")
    print(f"Modules with Global models: {len(modules)}")

    # List all model names for easy copying
    print(f"\n📝 ALL GLOBAL MODEL NAMES:")
    all_models = [model['model'] for model in models]
    print(", ".join(sorted(all_models)))

def main():
    # Default path to the ERP modules file
    default_path = Path(__file__).parent.parent / "structure" / "ERP_Modules.md"

    # Allow custom path as command line argument
    file_path = sys.argv[1] if len(sys.argv) > 1 else default_path

    print(f"🔍 Analyzing file: {file_path}")

    # Extract global models
    global_models = extract_global_models(file_path)

    # Print results
    print_global_models(global_models)

if __name__ == "__main__":
    main()
