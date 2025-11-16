#!/bin/bash

# Script para extraer modelos de ERP_Modules.md y organizarlos por scope
# Autor: Script generado automáticamente
# Fecha: $(date)

INPUT_FILE="/Users/julioortiz/Nov13ERP/ERP_Modules.md"
OUTPUT_FILE="/Users/julioortiz/Nov13ERP/Tables.v2.md"

echo "🔍 Extrayendo modelos de $INPUT_FILE..."

# Crear archivo de salida con header
cat > "$OUTPUT_FILE" << 'EOF'
# ERP Platform - Database Tables by Scope

Este archivo contiene todos los modelos/tablas del sistema ERP organizados por su scope de base de datos.

**Resumen de Scopes:**
- **Global**: Tablas compartidas entre todos los tenants (no requieren tenantId)
- **Hybrid**: Tablas que requieren tanto tenantId como globalId para operaciones externas/integraciones
- **Tenant**: Tablas específicas del tenant (requieren tenantId para operaciones)

EOF

# Extraer modelos por scope y contar
echo "📊 Procesando modelos por scope..."

# Extraer y contar Hybrid models
HYBRID_MODELS=$(grep -E "^\| [A-Za-z][A-Za-z0-9_]+ *\| Hybrid" "$INPUT_FILE" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}' | sort)
HYBRID_COUNT=$(echo "$HYBRID_MODELS" | grep -v '^$' | wc -l)

# Extraer y contar Global models  
GLOBAL_MODELS=$(grep -E "^\| [A-Za-z][A-Za-z0-9_]+ *\| Global" "$INPUT_FILE" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}' | sort)
GLOBAL_COUNT=$(echo "$GLOBAL_MODELS" | grep -v '^$' | wc -l)

# Extraer y contar Tenant models
TENANT_MODELS=$(grep -E "^\| [A-Za-z][A-Za-z0-9_]+ *\| Tenant" "$INPUT_FILE" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}' | sort)
TENANT_COUNT=$(echo "$TENANT_MODELS" | grep -v '^$' | wc -l)

# Calcular total
TOTAL_COUNT=$((HYBRID_COUNT + GLOBAL_COUNT + TENANT_COUNT))

echo "✅ Encontrados:"
echo "   - Hybrid: $HYBRID_COUNT modelos"
echo "   - Global: $GLOBAL_COUNT modelos" 
echo "   - Tenant: $TENANT_COUNT modelos"
echo "   - Total: $TOTAL_COUNT modelos"

# Agregar estadísticas al archivo
cat >> "$OUTPUT_FILE" << EOF

## Estadísticas

- **Hybrid Models**: $HYBRID_COUNT tablas
- **Global Models**: $GLOBAL_COUNT tablas  
- **Tenant Models**: $TENANT_COUNT tablas
- **Total Models**: $TOTAL_COUNT tablas

---

EOF

# Agregar Hybrid Tables
cat >> "$OUTPUT_FILE" << EOF
## Hybrid Tables 

Estas tablas son parte del modelo de datos híbrido y requieren tanto tenantId como globalId para operaciones:

**Casos de uso típicos:**
- Integración con sistemas externos
- URLs públicas y portales de clientes
- Funcionalidad de e-signature
- Comunicaciones cross-tenant
- APIs y webhooks

**Modelos ($HYBRID_COUNT):**

EOF

if [ -n "$HYBRID_MODELS" ]; then
    echo "$HYBRID_MODELS" | while read -r model; do
        [ -n "$model" ] && echo "- $model" >> "$OUTPUT_FILE"
    done
else
    echo "- (Ningún modelo híbrido encontrado)" >> "$OUTPUT_FILE"
fi

# Agregar Global Tables  
cat >> "$OUTPUT_FILE" << EOF

---

## Global Tables

Estas tablas son parte del modelo de datos global y no requieren tenantId para operaciones:

**Casos de uso típicos:**
- Gestión de usuarios y autenticación
- Configuración de tenants
- Permisos y recursos globales
- Modelos de AI compartidos
- Configuración del sistema

**Modelos ($GLOBAL_COUNT):**

EOF

if [ -n "$GLOBAL_MODELS" ]; then
    echo "$GLOBAL_MODELS" | while read -r model; do
        [ -n "$model" ] && echo "- $model" >> "$OUTPUT_FILE"
    done
else
    echo "- (Ningún modelo global encontrado)" >> "$OUTPUT_FILE"
fi

# Agregar Tenant Tables
cat >> "$OUTPUT_FILE" << EOF

---

## Tenant Tables

Estas tablas son parte del modelo de datos específico del tenant y requieren tenantId para operaciones:

**Casos de uso típicos:**
- Datos de negocio específicos del cliente
- Proyectos, estimaciones, facturas
- Inventario y recursos internos
- Empleados y nómina
- Configuraciones específicas del tenant

**Modelos ($TENANT_COUNT):**

EOF

if [ -n "$TENANT_MODELS" ]; then
    echo "$TENANT_MODELS" | while read -r model; do
        [ -n "$model" ] && echo "- $model" >> "$OUTPUT_FILE"
    done
else
    echo "- (Ningún modelo tenant encontrado)" >> "$OUTPUT_FILE"
fi

# Agregar footer
cat >> "$OUTPUT_FILE" << EOF

---

## Notas de Implementación

### Scope Definitions

1. **Global Scope**
   - Compartido entre todos los tenants
   - No incluye tenantId en la clave primaria
   - Ejemplos: Users, Permissions, AIModels

2. **Hybrid Scope** 
   - Específico del tenant pero con capacidades externas
   - Requiere tenantId + globalId/publicId
   - Soporta URLs públicas y APIs externas
   - Ejemplos: Estimates, Invoices, Projects con portales de clientes

3. **Tenant Scope**
   - Completamente aislado por tenant
   - Siempre requiere tenantId
   - Datos internos del negocio
   - Ejemplos: Employees, Internal Documents, Private Configurations

### Consideraciones de Arquitectura

- **Aislamiento**: Tenant scope asegura completo aislamiento de datos
- **Integración**: Hybrid scope permite integraciones seguras con APIs externas  
- **Eficiencia**: Global scope reduce duplicación de datos comunes
- **Escalabilidad**: Diseño optimizado para multi-tenancy empresarial

---

*Generado automáticamente desde ERP_Modules.md el $(date)*
EOF

echo "✨ Archivo generado exitosamente: $OUTPUT_FILE"
echo ""
echo "📋 Resumen final:"
echo "   - Hybrid: $HYBRID_COUNT modelos"
echo "   - Global: $GLOBAL_COUNT modelos"
echo "   - Tenant: $TENANT_COUNT modelos"
echo "   - Total: $TOTAL_COUNT modelos"
echo ""
echo "🎯 Archivo creado: Tables.v2.md"