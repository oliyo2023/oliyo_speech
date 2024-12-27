# Changelog

## [1.1.0] - 2024-04-01

### Added
- 新增ConfigService集中管理配置
- 添加Dio请求日志功能
- 实现TtsRequest请求参数封装

### Changed
- 重构TtsService使用依赖注入
- 优化ConversionController接口设计
- 更新ConversionInput组件适配新接口

### Fixed
- 修复网络请求超时问题
- 修正错误处理逻辑
- 解决语速和音量设置传递问题

## [1.0.1] - 2024-01-01

### Added
- 新增DeepSeek余额查询功能
- 添加聊天框和内容展示框组件
- 实现API配置集中管理

### Changed
- 重构余额查询逻辑使用GetX状态管理
- 优化API响应数据处理

### Fixed
- 修复余额显示为null的问题
- 修正API地址和Key的硬编码问题
