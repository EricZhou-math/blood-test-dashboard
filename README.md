# 血常规仪表盘

## 🔗 国内快速访问
推荐用手机扫描下方二维码，或直接访问链接：
`https://ericzhou-math.github.io/blood-test-dashboard/`
![项目访问二维码](https://cdn.jsdelivr.net/gh/EricZhou-math/blood-test-dashboard@main/qrcode.png?v=20251022)
- 备用：直接嵌入Base64见文件 `qrcode_base64.txt`
> 说明：jsDelivr 不渲染 HTML 页面，作为资源 CDN 较快；入口请使用上方 GitHub Pages 或 RawGitHack。
> RawGitHack 备用入口（可渲染 HTML）：`https://raw.githack.com/EricZhou-math/blood-test-dashboard/main/index.html`

## 项目简介

这是一个交互式血常规检测数据可视化仪表盘，专为化疗期间的血常规监测设计。

## 功能特点

- 📊 **多指标图表展示**：支持选择多个血常规指标同时显示
- 📅 **日期区间筛选**：可选择特定时间段进行分析
- 📈 **趋势线分析**：可叠加线性回归趋势线
- 🎨 **智能着色**：根据参考范围自动标记异常值
  - 绿色：正常范围
  - 红色：超出上限
  - 蓝色：低于下限

## 使用方法

1. 打开 `index.html` 文件
2. 在"选择指标"区域勾选要查看的血常规项目
3. 在"日期区间"区域选择分析时间段
4. 可选择显示趋势线进行趋势分析
5. 查看图表和表格中的数据变化

### 生成可分享二维码
- 默认链接（稳定）：`https://ericzhou-math.github.io/blood-test-dashboard/`
- 一键生成：
  ```bash
  cd blood-test-dashboard
  ./make_qr.sh
  ```
- 指定自定义链接：
  ```bash
  ./make_qr.sh https://your.domain/path/
  ```
- 或使用Python脚本：
  ```bash
  . ../.venv/bin/activate && python generate_qr.py
  # 或者指定链接
  python generate_qr.py https://your.domain/path/
  ```
- 生成文件：`qrcode.png`

## 文件说明

- `index.html` - 主仪表盘页面
- `blood-test-data.csv` - 血常规数据文件
- `chart.min.js` - 图表库文件
- `generate_qr.py` - 生成二维码的Python脚本
- `make_qr.sh` - 一键生成二维码脚本（自动安装依赖）
- `qrcode.png` - 生成的二维码图片

## 技术栈

- HTML5 + CSS3 + JavaScript
- Chart.js 图表库
- 响应式设计，支持移动端查看

## 适用场景

- 化疗期间血常规监测
- 医患沟通辅助工具
- 个人健康数据管理

---

## 二维码预览

直接扫码访问仪表盘（默认指向 GitHub Pages 主入口）：

![血常规仪表盘二维码](https://cdn.jsdelivr.net/gh/EricZhou-math/blood-test-dashboard@main/qrcode.png?v=20251022)

### 缓存刷新指南
- 单文件刷新：访问 `https://purge.jsdelivr.net/gh/EricZhou-math/blood-test-dashboard@main/index.html`
- 批量刷新建议：发布后等待 CDN 自动更新；或对变更的每个文件分别执行上述刷新。
- 版本切换：将链接中的 `@main` 改为 Git 标签（如 `@v1.0`）。
- 创建标签并推送：
  - `git tag v1.0`
  - `git push --tags`

如需更新链接，可使用脚本重新生成二维码：
- `./make_qr.sh https://your.domain/path/`
- 或 `python generate_qr.py https://your.domain/path/`

---

*本工具仅供参考，具体诊疗请咨询专业医生*