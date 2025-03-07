# epg

Electronic Program Guide

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## 生成 .ipa文件

### 步骤 1：配置Xcode项目禁用自动签名

1. 打开Flutter项目的iOS目录（`ios/Runner.xcodeproj`）于Xcode中。
2. 在项目导航器中选中**Runner**目标。
3. 转到 **Signing & Capabilities** 标签页。
4. 取消勾选 **Automatically manage signing**。
5. 确保 **Team** 设置为 `None`，其他签名相关字段留空（Code Signing Identity等）。

### 步骤 2：使用Flutter命令构建未签名的应用

在终端中运行以下命令，跳过代码签名：

```bash
flutter build ios --release --no-codesign
```

此命令会生成未签名的`Runner.app`文件，位于`build/ios/iphoneos/`目录下。

### 步骤 3：手动打包为IPA文件

1. **创建Payload文件夹**：

   ```bash
   mkdir -p Payload
   ```

2. **复制.app文件到Payload**：

   ```bash
   cp -r build/ios/iphoneos/Runner.app Payload/
   ```

3. **压缩成IPA文件**：

   ```bash
   zip -r app.ipa Payload
   ```

   生成的`app.ipa`即为未签名的IPA文件。

### 验证未签名状态

检查生成的`.app`是否未签名：

```bash
codesign -dv Payload/Runner.app
```

若输出`code object is not signed at all`，则确认未签名。
