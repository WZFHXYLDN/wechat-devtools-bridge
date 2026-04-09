# WeChat DevTools Bridge

An open-source Codex plugin that connects WeChat Mini Program tooling to MCP workflows.

## What it does

- Provides a local Codex plugin manifest
- Ships an MCP configuration for Windows
- Wraps the open-source `weapp-devtools-mcp` server
- Includes helper scripts to locate WeChat DevTools and check prerequisites

## Current approach

This plugin currently uses the community `weapp-devtools-mcp` server as the MCP backend and adds local Windows-friendly scripts around it.

That gives us a practical bridge for:

- checking WeChat DevTools availability
- connecting Codex to local Mini Program tooling
- preparing preview/upload style workflows

## Prerequisites

- Windows PowerShell
- Node.js 16+
- WeChat DevTools installed
- WeChat DevTools service port enabled

## Files

- `.codex-plugin/plugin.json`: Codex plugin manifest
- `.mcp.json`: MCP server wiring
- `scripts/check-prereqs.ps1`: local environment check
- `scripts/find-wechat-devtools.ps1`: locate a likely DevTools CLI path
- `scripts/start-weapp-devtools-mcp.ps1`: launches the MCP server

## Quick start

1. Open WeChat DevTools and enable the service port in security settings.
2. Run:

```powershell
./scripts/check-prereqs.ps1
```

3. If needed, set the CLI path explicitly:

```powershell
$env:WECHAT_DEVTOOLS_CLI = "C:\\Path\\To\\WeChatDevTools\\cli.bat"
```

4. Start the MCP bridge manually:

```powershell
./scripts/start-weapp-devtools-mcp.ps1
```

## MCP config

The bundled `.mcp.json` uses:

```json
{
  "mcpServers": {
    "wechat-devtools-bridge": {
      "command": "powershell.exe",
      "args": [
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        "./scripts/start-weapp-devtools-mcp.ps1"
      ]
    }
  }
}
```

## Notes

- The helper scripts are intentionally conservative and Windows-first.
- If you want a pure Node launch path later, we can add one.
- If you want to swap the backend MCP server later, keep the manifest and scripts, and only change `.mcp.json` plus the launcher script.
