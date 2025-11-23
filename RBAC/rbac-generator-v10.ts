#!/usr/bin/env tsx
import { Command } from "commander";
import { generateRBAC } from "./rbac-generator-core";

const program = new Command();

program
  .option("--validate-only", "Validate RBAC schema only")
  .option("--verbose", "Verbose output")
  .action(async (opts) => {
    await generateRBAC(opts);
  });

program.parse();

