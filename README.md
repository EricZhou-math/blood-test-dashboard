# 血常规仪表盘

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
- 默认链接：`https://ericzhou_math.gitee.io/blood-test-dashboard/`
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

直接扫码访问仪表盘（默认指向 Gitee Pages）：

![血常规仪表盘二维码](qrcode.png)

如需更新链接，可使用脚本重新生成二维码：
- `./make_qr.sh https://your.domain/path/`
- 或 `python generate_qr.py https://your.domain/path/`

---

*本工具仅供参考，具体诊疗请咨询专业医生*