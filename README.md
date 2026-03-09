# openClaw-oncall-SRE
A Lightweight, Agent-Native SRE Assistant for Automated Incident Response.

## Background
For SDEs and SREs, On-call is often synonymous with fragmented workflows and high cognitive load. When a production incident occurs, the typical routine involves:
1. Receiving a vague alert from Grafana.
2. Manually querying Loki or CloudWatch for logs.
3. Searching GitHub for recent commits to identify potential regressions.
4. Manually creating tickets and notifying stakeholders.

openClaw-oncall-SRE transforms this manual toil into an autonomous, closed-loop process. Built on OpenClaw and the Model Context Protocol (MCP), this project deploys a virtual "SRE Team" that monitors, diagnoses, and documents incidents without human intervention.

## Architecture: The Multi-Agent Loop
The system utilizes two specialized agents that collaborate via shared context:

- SRE-Agent (The Guardian): Performs proactive health checks. It identifies anomalies in metrics and gathers raw evidence (logs).

- Dev-Agent (The Fixer): Receives incident summaries, correlates them with recent code changes in GitHub, and creates actionable engineering tasks.

## Quick Start (Step-by-Step)
1. One-Command Initialization
Run our automated setup script to scaffold the project structure, install the OpenClaw CLI, and fetch required MCP plugins.

```
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/openClaw-oncall-SRE/main/init_oncall.sh
bash init_oncall.sh
```

2. Configure Your Credentials
Edit the generated mcp.json file. This file acts as the gateway between the LLM and your infrastructure.


```
{
  "mcpServers": {
    "slack": {
      "command": "npx", "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-your-token" }
    },
    "grafana": {
      "command": "npx", "args": ["-y", "@grafana/mcp-server"],
      "env": { "GRAFANA_URL": "https://your-org.grafana.net", "GRAFANA_TOKEN": "glsa_your_key" }
    },
    "github": {
      "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_pat" }
    }
  }
}
```

3. Launch the Agent
Start the OpenClaw daemon. It will automatically register the cron job defined in SCHEDULE.md.

```
# Start the resident process
openclaw start
```

##  Core Logic & Prompts
AGENTS.md (Operational Workflow)
The agents follow a strict Standard Operating Procedure (SOP):

**SRE-Agent Logic:**
- Monitor: Query grafana.query_prometheus every 10 mins. Focus on Error Rate > 1% or P99 Latency > 200ms.
- Diagnose: On anomaly, fetch the last 5 minutes of {level="error"} logs via grafana.get_loki_logs.
- Alert: Post a structured report to Slack #oncall-alerts.

**Dev-Agent Logic:**
- Trace: Receive the log summary. Call github.get_recent_commits for the affected service.
- Contextualize: Compare error patterns with code diffs.
- Document: Call github.create_issue with a "Potential Regression" tag and link it back to the Slack thread.

**SOUL.md (Persona Definition)**
- SRE-Agent: Analytical, data-driven, and concise. Avoids "noisy" alerts by verifying persistence before notifying.
- Dev-Agent: Pragmatic and technical. Focuses on mapping logs to specific lines of code or commits.

## Project Structure
```
openClaw-oncall-SRE/
├── mcp.json           # Plugin configurations and API credentials
├── SCHEDULE.md        # Native Cron schedule (e.g., */10 * * * *)
├── AGENTS.md          # Comprehensive Multi-Agent SOPs
├── SOUL.md            # Personas and reasoning principles
├── init_oncall.sh     # Automation bootstrap script
└── .claw/             # Execution logs and agent memory
```

## Why This Project?
Agent-Native: No complex Python/Node.js logic. The "code" is the documentation.

Privacy-First: If used with a local vLLM endpoint, your logs never leave your infrastructure.

Zero Toil: Eliminates the "Alert -> Log Search -> Git Search" manual loop.

## Contributing
Interested in adding support for Datadog, PagerDuty, or Kubernetes? Please check our contribution guidelines!
