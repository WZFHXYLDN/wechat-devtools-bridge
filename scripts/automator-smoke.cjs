const automator = require('miniprogram-automator');

const cliPath = process.env.WECHAT_DEVTOOLS_CLI || '';
const projectPath = process.env.WECHAT_PROJECT_PATH || '';
const wsEndpoint = process.env.WECHAT_WS_ENDPOINT || 'ws://127.0.0.1:9420';
const mode = process.env.WECHAT_AUTOMATOR_MODE || 'connect';

async function main() {
  if (mode === 'launch') {
    if (!cliPath || !projectPath) {
      throw new Error('WECHAT_DEVTOOLS_CLI and WECHAT_PROJECT_PATH are required for launch mode.');
    }
    const miniProgram = await automator.launch({
      cliPath,
      projectPath
    });
    console.log(JSON.stringify({ ok: true, mode, action: 'launch' }));
    await miniProgram.close();
    return;
  }

  const miniProgram = await automator.connect({ wsEndpoint });
  console.log(JSON.stringify({ ok: true, mode, action: 'connect', wsEndpoint }));
  await miniProgram.disconnect();
}

main().catch((error) => {
  console.error(error && error.message ? error.message : error);
  process.exit(1);
});
