#!/bin/bash

# openClaw-oncall-SRE Setup Script
set -e

echo "------------------------------------------------"
echo "🚀 Initializing openClaw-oncall-SRE Environment"
echo "------------------------------------------------"

# 1. Install OpenClaw CLI if not present
if ! command -v openclaw &> /dev/null; then
    echo "📦 Installing OpenClaw CLI..."
    npm install -g @openclaw/cli
fi

# 2. Initialize project structure
openclaw init .

# 3. Install MCP Skills (Plugins)
echo "🔌 Installing MCP Skills: Slack, Grafana, GitHub..."
npx clawhub install slack grafana github

# 4. Generate Core Logic Files
echo "📝 Generating AGENTS.md, SOUL.md, and SCHEDULE.md..."

# Create SCHEDULE.md
cat <<EOF > SCHEDULE.md
# Agent Execution Schedules
## Periodic System Health Audit
- **Cron Expression**: */10 * * * *
- **Task**: "Trigger SRE-Agent for health scan and RCA workflow."
EOF

# Create AGENTS.md (Simplified version for script, matches full version above)
cat <<EOF > AGENTS.md
## SRE-Agent Logic
- Query Grafana for Error Rate and Latency.
- If threshold breached, fetch logs and post to Slack.
- Sync context to Dev-Agent.

## Dev-Agent Logic
- Search GitHub for recent commits.
- Map logs to code changes.
- Create GitHub Issue and reply to Slack Thread.
EOF

# Create SOUL.md
cat <<EOF > SOUL.md
- SRE-Agent: Precise, data-driven SRE expert.
- Dev-Agent: Code-focused Senior Developer.
EOF

# 5. Create Configuration Template
echo "⚙️ Creating mcp.json template..."
cat <<EOF > mcp.json
{
  "mcpServers": {
    "slack": {
      "command": "npx", "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": { "SLACK_BOT_TOKEN": "YOUR_SLACK_TOKEN" }
    },
    "grafana": {
      "command": "npx", "args": ["-y", "@grafana/mcp-server"],
      "env": { "GRAFANA_URL": "YOUR_URL", "GRAFANA_TOKEN": "YOUR_KEY" }
    },
    "github": {
      "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_PAT" }
    }
  }
}
EOF

echo ""
echo "✅ Setup Complete!"
echo "👉 NEXT STEPS:"
echo "1. Fill in your credentials in 'mcp.json'."
echo "2. Run 'openclaw start' to begin autonomous on-call."
