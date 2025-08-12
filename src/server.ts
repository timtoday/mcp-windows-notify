import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import { WindowsNotifier } from './notification.js';
import { config } from './config.js';
import { NotificationConfig } from './types.js';

export class WindowsNotifyServer {
  private server: Server;
  private notifier: WindowsNotifier;

  constructor() {
    this.server = new Server(
      {
        name: config.name,
        version: config.version,
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.notifier = new WindowsNotifier();
    this.setupToolHandlers();
  }

  private setupToolHandlers(): void {
    // 列出可用工具
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'send_notification',
            description: '发送Windows系统通知',
            inputSchema: {
              type: 'object',
              properties: {
                message: {
                  type: 'string',
                  description: '通知消息内容'
                },
                title: {
                  type: 'string',
                  description: '通知标题（可选）'
                },
                icon: {
                  type: 'string',
                  enum: ['info', 'warning', 'error', 'success'],
                  description: '通知图标类型（可选）'
                },
                sound: {
                  type: 'boolean',
                  description: '是否播放声音（可选）'
                },
                timeout: {
                  type: 'number',
                  description: '通知显示时长（毫秒，可选）'
                },
                subtitle: {
                  type: 'string',
                  description: '通知副标题（可选）'
                }
              },
              required: ['message']
            }
          },
          {
            name: 'notify_task_complete',
            description: '发送任务完成通知',
            inputSchema: {
              type: 'object',
              properties: {
                taskName: {
                  type: 'string',
                  description: '任务名称'
                },
                details: {
                  type: 'string',
                  description: '任务详情（可选）'
                }
              },
              required: ['taskName']
            }
          },
          {
            name: 'notify_error',
            description: '发送错误通知',
            inputSchema: {
              type: 'object',
              properties: {
                errorMessage: {
                  type: 'string',
                  description: '错误消息'
                },
                details: {
                  type: 'string',
                  description: '错误详情（可选）'
                }
              },
              required: ['errorMessage']
            }
          },
          {
            name: 'notify_reminder',
            description: '发送提醒通知',
            inputSchema: {
              type: 'object',
              properties: {
                message: {
                  type: 'string',
                  description: '提醒消息'
                },
                subtitle: {
                  type: 'string',
                  description: '提醒副标题（可选）'
                }
              },
              required: ['message']
            }
          }
        ] as Tool[]
      };
    });

    // 处理工具调用
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      if (!args) {
        return {
          content: [
            {
              type: 'text',
              text: '错误: 缺少参数'
            }
          ],
          isError: true
        };
      }

      try {
        switch (name) {
          case 'send_notification': {
            const notificationConfig: NotificationConfig = {
              message: args.message as string,
              title: args.title as string,
              icon: args.icon as any,
              sound: args.sound as boolean,
              timeout: args.timeout as number,
              subtitle: args.subtitle as string
            };

            const result = await this.notifier.sendNotification(notificationConfig);
            return {
              content: [
                {
                  type: 'text',
                  text: JSON.stringify(result, null, 2)
                }
              ]
            };
          }

          case 'notify_task_complete': {
            const result = await this.notifier.notifyTaskComplete(
              args.taskName as string,
              args.details as string
            );
            return {
              content: [
                {
                  type: 'text',
                  text: JSON.stringify(result, null, 2)
                }
              ]
            };
          }

          case 'notify_error': {
            const result = await this.notifier.notifyError(
              args.errorMessage as string,
              args.details as string
            );
            return {
              content: [
                {
                  type: 'text',
                  text: JSON.stringify(result, null, 2)
                }
              ]
            };
          }

          case 'notify_reminder': {
            const result = await this.notifier.notifyReminder(
              args.message as string,
              args.subtitle as string
            );
            return {
              content: [
                {
                  type: 'text',
                  text: JSON.stringify(result, null, 2)
                }
              ]
            };
          }

          default:
            throw new Error(`未知工具: ${name}`);
        }
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `错误: ${error instanceof Error ? error.message : String(error)}`
            }
          ],
          isError: true
        };
      }
    });
  }

  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Windows通知MCP服务器已启动');
  }
}
