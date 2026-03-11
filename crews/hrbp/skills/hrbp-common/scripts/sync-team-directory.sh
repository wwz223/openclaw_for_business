#!/bin/bash
# sync-team-directory.sh - Generate team directory from openclaw.json
# Writes a single canonical file at ~/.openclaw/TEAM_DIRECTORY.md.
# All agents can read it directly (workspaceOnly is off by default).
set -e

OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
CONFIG_PATH="${CONFIG_PATH:-$OPENCLAW_HOME/openclaw.json}"
TEAM_DIRECTORY_PATH="${TEAM_DIRECTORY_PATH:-$OPENCLAW_HOME/TEAM_DIRECTORY.md}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "⚠️  Config not found: $CONFIG_PATH"
  exit 0
fi

CONFIG_PATH="$CONFIG_PATH" TEAM_DIRECTORY_PATH="$TEAM_DIRECTORY_PATH" node -e '
const fs = require("fs");
const path = require("path");
const os = require("os");

const configPath = process.env.CONFIG_PATH;
const teamDirectoryPath = process.env.TEAM_DIRECTORY_PATH;
const home = process.env.HOME || "";

let config;
try {
  config = JSON.parse(fs.readFileSync(configPath, "utf8"));
} catch (err) {
  console.error("❌ Failed to parse " + configPath + ": " + err.message);
  process.exit(1);
}

const agents = Array.isArray(config?.agents?.list) ? config.agents.list : [];
const bindings = Array.isArray(config?.bindings) ? config.bindings : [];
const main = agents.find((agent) => agent.id === "main");
const allowSet = new Set(
  Array.isArray(main?.subagents?.allowAgents) ? main.subagents.allowAgents : []
);

function resolveWorkspace(rawWorkspace, agentId) {
  const fallback = `~/.openclaw/workspace-${agentId}`;
  const value = typeof rawWorkspace === "string" && rawWorkspace.trim()
    ? rawWorkspace.trim()
    : fallback;
  return value.replace(/^~(?=\/|$)/, home);
}

function parseRole(workspacePath) {
  const identityPath = path.join(workspacePath, "IDENTITY.md");
  if (!fs.existsSync(identityPath)) return "—";

  const content = fs.readFileSync(identityPath, "utf8");
  const roleMatch = content.match(/##\s*Role\s*\n([\s\S]*?)(?:\n##\s|\n#\s|$)/);
  if (!roleMatch) return "—";

  const summary = roleMatch[1]
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean)
    .join(" ");

  if (!summary) return "—";
  return summary.replace(/\|/g, "/").slice(0, 160);
}

function routeMode(agentId, hasBinding, isSpawnable) {
  if (agentId === "main") return "entry";
  if (hasBinding && isSpawnable) return "both";
  if (hasBinding) return "binding";
  if (isSpawnable) return "spawn";
  return "none";
}

const lines = [];
lines.push("# Team Directory");
lines.push("");
lines.push("_Generated from `" + configPath + "` at " + new Date().toISOString() + "._");
lines.push("");
lines.push("| ID | Name | Role | Route | Bindings | Status |");
lines.push("|----|------|------|-------|----------|--------|");

for (const agent of agents) {
  const id = agent.id || "unknown";
  const name = agent.name || id;
  const workspacePath = resolveWorkspace(agent.workspace, id);
  const agentBindings = bindings.filter((entry) => entry.agentId === id);
  const hasBinding = agentBindings.length > 0;
  const isSpawnable = id === "main" || allowSet.has(id);
  const route = routeMode(id, hasBinding, isSpawnable);
  const bindingsLabel = hasBinding
    ? agentBindings
      .map((entry) => `${entry?.match?.channel || "unknown"}:${entry?.match?.accountId || "*"}`)
      .join(", ")
    : "—";
  const status = fs.existsSync(workspacePath) ? "active" : "registered";
  const role = parseRole(workspacePath);
  lines.push(
    `| ${id} | ${name.replace(/\|/g, "/")} | ${role} | ${route} | ${bindingsLabel.replace(/\|/g, "/")} | ${status} |`
  );
}

lines.push("");
const content = lines.join("\n");

// Atomic write: write to temp file then rename
const tmpPath = teamDirectoryPath + ".tmp." + process.pid;
try {
  fs.writeFileSync(tmpPath, content);
  fs.renameSync(tmpPath, teamDirectoryPath);
} catch (err) {
  // Clean up temp file on failure
  try { fs.unlinkSync(tmpPath); } catch (_) {}
  throw err;
}
'

echo "✅ Team directory synchronized: $TEAM_DIRECTORY_PATH"
