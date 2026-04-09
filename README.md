# WeChat DevTools Bridge

An open-source Codex plugin that connects WeChat Mini Program tooling to MCP and automation workflows.

## What it does

- Provides a local Codex plugin manifest
- Ships an MCP configuration for Windows
- Adds helper scripts to locate WeChat DevTools and check prerequisites
- Provides executable wrappers for open, preview, upload, and automator smoke tests

## Current approach

This plugin uses official WeChat-adjacent tooling for the executable path and keeps MCP pluggable.

That gives us a practical bridge for:

- checking WeChat DevTools availability
- connecting Codex to local Mini Program tooling
- opening, previewing, and uploading projects
- validating automator connectivity

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
- `scripts/invoke-weapp-cli.ps1`: shared wrapper around `weapp-ide-cli`
- `scripts/open-project.ps1`: open the current project in WeChat DevTools
- `scripts/preview-project.ps1`: run a preview flow
- `scripts/upload-project.ps1`: run an upload flow
- `scripts/start-weapp-devtools-mcp.ps1`: launches a configurable MCP package
- `scripts/automator-smoke.cjs`: validates `miniprogram-automator` connectivity
- `package.json`: npm dependencies and convenience scripts

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

5. Open the current mini program project:

```powershell
./scripts/open-project.ps1
```

6. Run an automator smoke test after DevTools is exposing the websocket endpoint:

```powershell
$env:WECHAT_WS_ENDPOINT = "ws://127.0.0.1:9420"
npm run automator:smoke
```

## npm scripts

```bash
npm install
npm run check
npm run devtools:open
npm run devtools:preview
npm run automator:smoke
```

`devtools:upload` requires additional arguments, for example:

```powershell
./scripts/upload-project.ps1 -Version 0.1.0 -Desc "Initial upload"
```

## Environment variables

- `WECHAT_DEVTOOLS_CLI`: explicit path to the DevTools CLI
- `WECHAT_PROJECT_PATH`: mini program project root
- `WECHAT_WS_ENDPOINT`: automator websocket endpoint, default `ws://127.0.0.1:9420`
- `WECHAT_MCP_NPX_PACKAGE`: optional community MCP package name used by `start-weapp-devtools-mcp.ps1`

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

## Recommended toolchain

- `weapp-ide-cli`: open / preview / upload wrappers around the WeChat DevTools CLI
- `miniprogram-automator`: websocket-based DevTools automation checks
- a community WeChat DevTools MCP package of your choice, passed via `WECHAT_MCP_NPX_PACKAGE`

## Upstream references

- `miniprogram-automator`: https://www.npmjs.com/package/miniprogram-automator
- `weapp-ide-cli`: https://www.npmjs.com/package/weapp-ide-cli
- community MCP example: https://glama.ai/mcp/servers/%40yfmeii/weapp-dev-mcp

## Notes

- The helper scripts are intentionally conservative and Windows-first.
- The repository keeps the MCP backend configurable because community MCP packages evolve quickly.
- If you want a pure Node launch path later, we can add one.
