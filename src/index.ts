#!/usr/bin/env node

import { WindowsNotifyServer } from './server.js';

async function main() {
  const server = new WindowsNotifyServer();
  await server.run();
}

// 处理未捕获的异常
process.on('uncaughtException', (error) => {
  console.error('未捕获的异常:', error);
  process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('未处理的Promise拒绝:', reason);
  process.exit(1);
});

main().catch((error) => {
  console.error('服务器启动失败:', error);
  process.exit(1);
});
