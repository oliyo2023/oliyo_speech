# Changelog

## [1.2.0] - 2024-01-01

### Changed
- 修改BalanceController以使用PocketBase获取deepseek_api_key
- 移除无用的DEEPSEEK_API_KEY配置项

## [1.1.0] - 2024-01-01

### Added
- TtsService音频缓存功能
- PocketBaseService重试机制

### Changed
- 提取窗口配置到WindowConfig类
- 改进PocketBaseService错误处理
- 优化代码结构和可维护性

### Fixed
- 修复PocketBaseService日志记录依赖问题
