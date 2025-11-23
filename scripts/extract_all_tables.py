#!/usr/bin/env python3
"""
Script to extract ALL table names from ERP_AUTHORITATIVE_MODULE_STRUCTURE_v2.0.md
Extracts every table mentioned in the document organized by module and scope.
"""

import re
from pathlib import Path

def extract_all_tables():
    """Extract all table names from the authoritative structure file"""

    file_path = Path(__file__).parent.parent / "ERP_AUTHORITATIVE_MODULE_STRUCTURE_v2.0.md"

    if not file_path.exists():
        print(f"❌ File not found: {file_path}")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')

    global_tables = []
    tenant_tables = []
    current_module = None
    current_scope = None
    in_global_section = False
    in_tenant_section = False

    for i, line in enumerate(lines):
        line = line.strip()

        # Detect module headers
        if line.startswith('## ') and ('(GLOBAL)' in line or '(HYBRID)' in line or '(TENANT)' in line):
            # Extract module name and scope
            match = re.search(r'## \d+\. (.+?) \((.+?)\)', line)
            if match:
                current_module = match.group(1)
                current_scope = match.group(2)
                in_global_section = False
                in_tenant_section = False

        # Detect table scope sections
        if 'GLOBAL Tables' in line and ':' in line:
            in_global_section = True
            in_tenant_section = False
        elif 'TENANT Tables' in line and ':' in line:
            in_global_section = False
            in_tenant_section = True
        elif line.startswith('### ') or line.startswith('## '):
            in_global_section = False
            in_tenant_section = False

        # Extract table names from bullet points
        if line.startswith('- **') and '**:' in line:
            # Extract table name between ** markers
            match = re.search(r'- \*\*([^*]+)\*\*:', line)
            if match:
                table_name = match.group(1)

                table_info = {
                    'name': table_name,
                    'module': current_module,
                    'module_scope': current_scope,
                    'table_scope': 'GLOBAL' if in_global_section else 'TENANT' if in_tenant_section else 'UNKNOWN'
                }

                if in_global_section:
                    global_tables.append(table_info)
                elif in_tenant_section:
                    tenant_tables.append(table_info)
                else:
                    # For modules where scope isn't explicitly marked, infer from module scope
                    if current_scope == 'GLOBAL' and 'PublicLink' not in table_name:
                        global_tables.append(table_info)
                    else:
                        tenant_tables.append(table_info)

    return global_tables, tenant_tables

def main():
    print("🔍 Extracting ALL tables from ERP_AUTHORITATIVE_MODULE_STRUCTURE_v2.0.md")
    print("=" * 80)

    global_tables, tenant_tables = extract_all_tables()

    print(f"\n📊 SUMMARY")
    print(f"Global tables: {len(global_tables)}")
    print(f"Tenant tables: {len(tenant_tables)}")
    print(f"Total tables: {len(global_tables) + len(tenant_tables)}")

    print(f"\n🌐 GLOBAL TABLES ({len(global_tables)} total)")
    print("=" * 60)

    current_module = None
    for table in global_tables:
        if table['module'] != current_module:
            current_module = table['module']
            print(f"\n📋 {current_module} ({table['module_scope']})")
            print("-" * 40)

        print(f"  • {table['name']}")

    print(f"\n🏢 TENANT TABLES ({len(tenant_tables)} total)")
    print("=" * 60)

    current_module = None
    for table in tenant_tables:
        if table['module'] != current_module:
            current_module = table['module']
            print(f"\n📋 {current_module} ({table['module_scope']})")
            print("-" * 40)

        print(f"  • {table['name']}")

    print(f"\n📝 ALL TABLE NAMES (Alphabetical)")
    print("=" * 60)

    all_tables = [t['name'] for t in global_tables + tenant_tables]
    all_tables.sort()

    for i, table in enumerate(all_tables, 1):
        print(f"{i:3d}. {table}")

if __name__ == "__main__":
    main()
