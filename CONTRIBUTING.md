# 贡献指南

感谢您对MCP Windows通知插件的贡献！

## 开发环境设置

1. **克隆仓库**
   ```bash
   git clone https://github.com/YOUR_USERNAME/mcp-windows-notify.git
   cd mcp-windows-notify
   ```

2. **安装依赖**
   ```bash
   npm install
   ```

3. **构建项目**
   ```bash
   npm run build
   ```

4. **本地测试**
   ```bash
   npm install -g .
   mcp-windows-notify
   ```

## 开发流程

1. **创建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **进行开发**
   - 修改源代码在 `src/` 目录
   - 运行 `npm run build` 编译
   - 测试功能是否正常

3. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加新功能描述"
   ```

4. **推送并创建PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## 代码规范

- 使用TypeScript编写代码
- 遵循现有的代码风格
- 添加适当的类型注解
- 更新相关文档

## 测试

在提交PR之前，请确保：
- [ ] 代码能够成功编译
- [ ] 本地安装测试通过
- [ ] Windows通知功能正常工作
- [ ] 更新了相关文档

## 发布流程

维护者发布新版本的步骤：

1. 更新版本号
2. 创建GitHub Release
3. 自动发布到NPM（通过GitHub Actions）
