#!/usr/bin/env node
/*
  Verifies ERP_AUTHORITATIVE_MODULE_STRUCTURE_v2.0.md by parsing modules, scopes,
  and table counts. Outputs per-module details and overall totals, and flags mismatches.
*/
import fs from "node:fs";
import path from "node:path";

const fileArg =
  process.argv[2] ||
  path.resolve(process.cwd(), "ERP_AUTHORITATIVE_MODULE_STRUCTURE_v2.0.md");
const md = fs.readFileSync(fileArg, "utf8");
const lines = md.split(/\r?\n/);

const moduleHeaderRe = /^##\s+(\d+)\.\s+(.+?)\s+\((GLOBAL|HYBRID|TENANT)\)/;
const tablesHeaderRe = /###\s+Tables\s*\((\d+)\)/;
const subTablesHeaderRe = /####\s+(GLOBAL|TENANT) Tables\s*\((\d+)\)/g;
const bulletTableRe = /^-\s+\*\*(.+?)\*\*/;

const modules = [];

for (let i = 0; i < lines.length; i++) {
  const m = lines[i].match(moduleHeaderRe);
  if (!m) continue;
  const idx = parseInt(m[1], 10);
  const nameRaw = m[2].trim();
  const name = nameRaw.replace(/\s*⭐.*$/, ""); // strip stars/notes
  const scope = m[3];

  // Find section end (next module header or end of file)
  let j = i + 1;
  while (j < lines.length && !moduleHeaderRe.test(lines[j])) j++;
  const section = lines.slice(i, j).join("\n");

  // Declared total tables
  const declaredTotalMatch = section.match(tablesHeaderRe);
  const declaredTotal = declaredTotalMatch
    ? parseInt(declaredTotalMatch[1], 10)
    : null;

  // Declared subtotals for GLOBAL/TENANT when present
  const subMatches = [...section.matchAll(subTablesHeaderRe)];
  const declaredSubs = {};
  for (const sm of subMatches) {
    declaredSubs[sm[1]] = (declaredSubs[sm[1]] || 0) + parseInt(sm[2], 10);
  }

  // Determine default bullet table scope
  let defaultBulletScope = null;
  if (/###\s+Tables\s*\(\d+\).*ALL TENANT-SCOPED/i.test(section)) {
    defaultBulletScope = "TENANT";
  }

  // Count bullet tables and attribute to GLOBAL/TENANT table scope
  let currentSubScope = defaultBulletScope;
  let bulletCount = 0;
  let bulletByTableScope = { GLOBAL: 0, TENANT: 0 };
  let publicLinkCount = 0;
  for (const ln of section.split("\n")) {
    const sub = ln.match(/####\s+(GLOBAL|TENANT) Tables/i);
    if (sub) {
      currentSubScope = sub[1].toUpperCase();
      continue;
    }
    const b = ln.trim().match(bulletTableRe);
    if (b) {
      bulletCount++;
      const tScope = currentSubScope || "TENANT";
      if (bulletByTableScope[tScope] !== undefined)
        bulletByTableScope[tScope]++;
      if (/PublicLink|InviteLink|TrackingLink/i.test(b[1])) publicLinkCount++;
    }
  }

  modules.push({
    index: idx,
    name,
    scope,
    declaredTotal,
    declaredSubs,
    bulletCount,
    bulletByTableScope,
    publicLinkCount,
  });

  // Advance pointer
  i = j - 1;
}

// Aggregate statistics
const scopes = ["GLOBAL", "HYBRID", "TENANT"];
const totals = {
  modulesByScope: { GLOBAL: 0, HYBRID: 0, TENANT: 0 },
  declaredTablesByScope: { GLOBAL: 0, HYBRID: 0, TENANT: 0 },
  countedTablesByScope: { GLOBAL: 0, HYBRID: 0, TENANT: 0 },
  tableScopeDistribution: { GLOBAL: 0, TENANT: 0 },
  publicLinkTables: 0,
};

for (const mod of modules) {
  totals.modulesByScope[mod.scope]++;
  if (typeof mod.declaredTotal === "number")
    totals.declaredTablesByScope[mod.scope] += mod.declaredTotal;
  totals.countedTablesByScope[mod.scope] += mod.bulletCount;
  if (mod.bulletByTableScope) {
    totals.tableScopeDistribution.GLOBAL += mod.bulletByTableScope.GLOBAL || 0;
    totals.tableScopeDistribution.TENANT += mod.bulletByTableScope.TENANT || 0;
  }
  if (mod.name !== "publicLinkEngine") {
    totals.publicLinkTables += mod.publicLinkCount;
  }
}

const sum = (obj) => Object.values(obj).reduce((a, b) => a + b, 0);

const output = {
  file: path.basename(fileArg),
  modulesAnalyzed: modules.length,
  perModule: modules
    .sort((a, b) => a.index - b.index)
    .map((m) => ({
      index: m.index,
      name: m.name,
      scope: m.scope,
      declaredTables: m.declaredTotal,
      countedTables: m.bulletCount,
      tablesMatch:
        typeof m.declaredTotal === "number"
          ? m.declaredTotal === m.bulletCount
          : null,
      declaredSubtotals: m.declaredSubs,
      publicLinkTablesInModule: m.publicLinkCount,
    })),
  totals: {
    modulesByScope: totals.modulesByScope,
    modulesTotal: sum(totals.modulesByScope),
    declaredTablesByScope: totals.declaredTablesByScope,
    declaredTablesTotal: sum(totals.declaredTablesByScope),
    countedTablesByScope: totals.countedTablesByScope,
    countedTablesTotal: sum(totals.countedTablesByScope),
    tableScopeDistribution: totals.tableScopeDistribution,
    tableScopeTotal: sum(totals.tableScopeDistribution),
    publicLinkTables: totals.publicLinkTables,
  },
  mismatches: modules
    .filter(
      (m) =>
        typeof m.declaredTotal === "number" && m.declaredTotal !== m.bulletCount
    )
    .map((m) => ({
      index: m.index,
      name: m.name,
      scope: m.scope,
      declared: m.declaredTotal,
      counted: m.bulletCount,
    })),
};

// Pretty print
console.log("== Module Verification Report ==");
console.log(`File: ${output.file}`);
console.log(`Modules analyzed: ${output.modulesAnalyzed}`);
console.log("\n-- Per Module --");
for (const m of output.perModule) {
  const flag = m.tablesMatch === null ? "?" : m.tablesMatch ? "OK" : "MISMATCH";
  console.log(
    `${String(m.index).padStart(2, " ")}. ${m.name} [${m.scope}] -> declared: ${
      m.declaredTables ?? "n/a"
    }, counted: ${m.countedTables} => ${flag}`
  );
}

console.log("\n-- Totals --");
for (const sc of scopes) {
  console.log(
    `${sc}: modules=${output.totals.modulesByScope[sc]}, declaredTables=${output.totals.declaredTablesByScope[sc]}, countedTables=${output.totals.countedTablesByScope[sc]}`
  );
}
console.log(
  `TOTAL: modules=${output.totals.modulesTotal}, declaredTables=${output.totals.declaredTablesTotal}, countedTables=${output.totals.countedTablesTotal}, publicLinkTables=${output.totals.publicLinkTables}`
);

if (output.mismatches.length) {
  console.log("\n-- Mismatches --");
  for (const mm of output.mismatches) {
    console.log(
      `${mm.index}. ${mm.name} [${mm.scope}] declared=${mm.declared} counted=${mm.counted}`
    );
  }
}

// Print table-scope totals (GLOBAL vs TENANT tables)
console.log("\n-- Table Scope Distribution (by table-level scope) --");
console.log(
  `GLOBAL tables: ${output.totals.tableScopeDistribution.GLOBAL}, TENANT tables: ${output.totals.tableScopeDistribution.TENANT}, TOTAL tables: ${output.totals.tableScopeTotal}`
);

// Also check against the summary section if present
const systemStatsMatch = md.match(
  /\|\s*\*\*GLOBAL\*\*\s*\|\s*(\d+)\s*\|\s*(\d+)/
);
const hybridStatsMatch = md.match(
  /\|\s*\*\*HYBRID\*\*\s*\|\s*(\d+)\s*\|\s*(\d+)/
);
const tenantStatsMatch = md.match(
  /\|\s*\*\*TENANT\*\*\s*\|\s*(\d+)\s*\|\s*(\d+)/
);
const totalStatsMatch = md.match(
  /\|\s*\*\*TOTAL\*\*\s*\|\s*\*\*(\d+)\*\*\s*\|\s*\*\*(\d+)\*\*/
);

if (
  systemStatsMatch &&
  hybridStatsMatch &&
  tenantStatsMatch &&
  totalStatsMatch
) {
  const docStats = {
    GLOBAL: { modules: +systemStatsMatch[1], tables: +systemStatsMatch[2] },
    HYBRID: { modules: +hybridStatsMatch[1], tables: +hybridStatsMatch[2] },
    TENANT: { modules: +tenantStatsMatch[1], tables: +tenantStatsMatch[2] },
    TOTAL: { modules: +totalStatsMatch[1], tables: +totalStatsMatch[2] },
  };
  console.log("\n-- Comparison vs Document Summary --");
  for (const sc of scopes) {
    const modOk = docStats[sc].modules === output.totals.modulesByScope[sc];
    const tabOk =
      docStats[sc].tables === output.totals.countedTablesByScope[sc];
    console.log(
      `${sc}: modules doc=${docStats[sc].modules} parsed=${
        output.totals.modulesByScope[sc]
      } => ${modOk ? "OK" : "MISMATCH"}, tables doc=${
        docStats[sc].tables
      } parsed=${output.totals.countedTablesByScope[sc]} => ${
        tabOk ? "OK" : "MISMATCH"
      }`
    );
  }
  const totalModulesOk = docStats.TOTAL.modules === output.totals.modulesTotal;
  const totalTablesOk =
    docStats.TOTAL.tables === output.totals.countedTablesTotal;
  console.log(
    `TOTAL: modules doc=${docStats.TOTAL.modules} parsed=${
      output.totals.modulesTotal
    } => ${totalModulesOk ? "OK" : "MISMATCH"}, tables doc=${
      docStats.TOTAL.tables
    } parsed=${output.totals.countedTablesTotal} => ${
      totalTablesOk ? "OK" : "MISMATCH"
    }`
  );
}

// Compare with 'Table Distribution by Scope' if present
const globalTablesCountMatch = md.match(/\*\*GLOBAL tables\*\* \|\s*(\d+)/i);
const tenantTablesCountMatch = md.match(/\*\*TENANT tables\*\* \|\s*(\d+)/i);
if (globalTablesCountMatch && tenantTablesCountMatch) {
  const docGlobalTables = +globalTablesCountMatch[1];
  const docTenantTables = +tenantTablesCountMatch[1];
  const okGlobal =
    docGlobalTables === output.totals.tableScopeDistribution.GLOBAL;
  const okTenant =
    docTenantTables === output.totals.tableScopeDistribution.TENANT;
  console.log("\n-- Comparison vs Table Distribution by Scope --");
  console.log(
    `GLOBAL tables doc=${docGlobalTables} parsed=${
      output.totals.tableScopeDistribution.GLOBAL
    } => ${okGlobal ? "OK" : "MISMATCH"}`
  );
  console.log(
    `TENANT tables doc=${docTenantTables} parsed=${
      output.totals.tableScopeDistribution.TENANT
    } => ${okTenant ? "OK" : "MISMATCH"}`
  );
}
