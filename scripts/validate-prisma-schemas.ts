#!/usr/bin/env npx tsx

/**
 * 🔍 Prisma Schema Validator for RLS Generation
 *
 * Validates that Prisma schemas are ready for RLS policy generation
 * Checks for required fields, proper naming, and tenant isolation
 */

import fs from "fs";
import path from "path";

interface ValidationResult {
  isValid: boolean;
  warnings: string[];
  errors: string[];
  tableCount: number;
  tenantScopedCount: number;
  globalCount: number;
}

interface ModelInfo {
  name: string;
  file: string;
  hasTenantId: boolean;
  hasDeletedAt: boolean;
  hasCreatedByActorId: boolean;
  hasGlobalId: boolean;
  isPublicLink: boolean;
}

const PRISMA_SCHEMAS_DIR = "./prisma/schemas";

// Expected GLOBAL modules (should NOT have tenantId)
const GLOBAL_MODULES = [
  "identityCore.prisma",
  "identityAuthN.prisma",
  "platformRegistry.prisma",
  "publicLinkEngine.prisma",
  "identityAuthZ.prisma",
];

// Tables that should have soft delete
const EXPECTED_SOFT_DELETE = [
  "Estimate",
  "Invoice",
  "Project",
  "ChangeOrder",
  "Contract",
  "Document",
  "RFI",
  "Submittal",
  "WorkOrder",
  "CRMAccount",
  "CRMContact",
  "Member",
  "UserInvitation",
];

function validatePrismaSchemas(): ValidationResult {
  const result: ValidationResult = {
    isValid: true,
    warnings: [],
    errors: [],
    tableCount: 0,
    tenantScopedCount: 0,
    globalCount: 0,
  };

  console.log("🔍 Validating Prisma schemas for RLS compatibility...\n");

  if (!fs.existsSync(PRISMA_SCHEMAS_DIR)) {
    result.errors.push(
      `Prisma schemas directory not found: ${PRISMA_SCHEMAS_DIR}`
    );
    result.isValid = false;
    return result;
  }

  const schemaFiles = fs
    .readdirSync(PRISMA_SCHEMAS_DIR)
    .filter((file) => file.endsWith(".prisma"));

  console.log(`📁 Found ${schemaFiles.length} schema files`);

  const allModels: ModelInfo[] = [];

  // Analyze each schema file
  for (const file of schemaFiles) {
    const filePath = path.join(PRISMA_SCHEMAS_DIR, file);
    const content = fs.readFileSync(filePath, "utf-8");

    console.log(`\n📄 Analyzing ${file}...`);

    // Extract models
    const modelMatches = content.matchAll(/model\s+(\w+)\s*{([^}]+)}/g);

    for (const match of modelMatches) {
      const modelName = match[1];
      const modelBody = match[2];

      // Remove comments when checking for field existence
      const modelBodyWithoutComments = modelBody
        .replace(/\/\/.*$/gm, "") // Remove single-line comments
        .replace(/\/\*[\s\S]*?\*\//g, ""); // Remove multi-line comments

      const model: ModelInfo = {
        name: modelName,
        file,
        hasTenantId: modelBodyWithoutComments.includes("tenantId"),
        hasDeletedAt: modelBodyWithoutComments.includes("deletedAt"),
        hasCreatedByActorId:
          modelBodyWithoutComments.includes("createdByActorId"),
        hasGlobalId: modelBodyWithoutComments.includes("globalId"),
        isPublicLink: modelName.endsWith("PublicLink"),
      };

      allModels.push(model);
      result.tableCount++;

      // Validate based on module type
      if (GLOBAL_MODULES.includes(file)) {
        // GLOBAL modules should NOT have tenantId
        result.globalCount++;
        if (model.hasTenantId) {
          result.errors.push(
            `❌ ${file}::${modelName}: GLOBAL model should NOT have tenantId`
          );
        }
      } else {
        // HYBRID/TENANT modules should HAVE tenantId
        result.tenantScopedCount++;
        if (!model.hasTenantId) {
          result.errors.push(
            `❌ ${file}::${modelName}: Non-GLOBAL model MUST have tenantId`
          );
        }

        // Check for required fields in HYBRID parent tables
        if (model.isPublicLink) {
          if (!model.hasGlobalId) {
            result.warnings.push(
              `⚠️  ${file}::${modelName}: PublicLink table should have globalId`
            );
          }
        }

        // Check soft delete expectation
        if (EXPECTED_SOFT_DELETE.includes(modelName) && !model.hasDeletedAt) {
          result.warnings.push(
            `⚠️  ${file}::${modelName}: Expected to have soft delete (deletedAt)`
          );
        }
      }

      console.log(
        `   📋 ${modelName}: ${model.hasTenantId ? "✅ tenant" : "🌐 global"} ${
          model.hasDeletedAt ? "🗑️ soft" : ""
        } ${model.hasGlobalId ? "🔗 global" : ""}`
      );
    }
  }

  // Cross-module validation
  console.log(`\n🔍 Cross-module validation...`);

  // Check for naming consistency
  const tableNames = allModels.map((m) => m.name.toLowerCase());
  const duplicates = tableNames.filter(
    (name, index) => tableNames.indexOf(name) !== index
  );
  if (duplicates.length > 0) {
    result.errors.push(
      `❌ Duplicate table names found: ${[...new Set(duplicates)].join(", ")}`
    );
  }

  // Validate HYBRID pattern compliance
  const hybridParents = allModels.filter(
    (m) => !GLOBAL_MODULES.includes(m.file) && !m.isPublicLink && m.hasGlobalId
  );

  for (const parent of hybridParents) {
    const expectedPublicLink = `${parent.name}PublicLink`;
    const hasPublicLink = allModels.some((m) => m.name === expectedPublicLink);

    if (!hasPublicLink) {
      result.warnings.push(
        `⚠️  ${parent.name}: HYBRID parent should have ${expectedPublicLink} table`
      );
    }
  }

  // Summary
  console.log(`\n📊 Validation Summary:`);
  console.log(`   • Total models: ${result.tableCount}`);
  console.log(`   • Global models: ${result.globalCount}`);
  console.log(`   • Tenant-scoped models: ${result.tenantScopedCount}`);
  console.log(`   • Errors: ${result.errors.length}`);
  console.log(`   • Warnings: ${result.warnings.length}`);

  if (result.errors.length > 0) {
    result.isValid = false;
    console.log(`\n❌ ERRORS:`);
    result.errors.forEach((error) => console.log(`   ${error}`));
  }

  if (result.warnings.length > 0) {
    console.log(`\n⚠️  WARNINGS:`);
    result.warnings.forEach((warning) => console.log(`   ${warning}`));
  }

  if (result.isValid) {
    console.log(`\n✅ Schemas are valid for RLS policy generation!`);
  } else {
    console.log(`\n❌ Please fix errors before generating RLS policies.`);
  }

  return result;
}

// CLI execution
if (require.main === module) {
  const result = validatePrismaSchemas();
  process.exit(result.isValid ? 0 : 1);
}

export { validatePrismaSchemas };
