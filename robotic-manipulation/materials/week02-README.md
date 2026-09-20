# 机器人操作·第二周 MATLAB 教学代码

面向 **MATLAB R2025a (macOS)**，对应课件《坐标系与正运动学》。代码尽量覆盖课件中的计算例子、数值检查、二维/三维旋转、齐次变换、坐标链、平面 1R/2R 正运动学、通用串联链，以及现成机械臂 UR5e 的 `rigidBodyTree` 示例。

## 环境

- MATLAB R2025a
- demos 01–15、18：仅使用基础 MATLAB（无 Robotics System Toolbox 也可运行）
- demos 16–17：需要 **Robotics System Toolbox**，使用 `loadrobot("universalUR5e")`
- 若 `loadrobot` 或机器人网格不可用，请在 Add-On Explorer 中安装/检查 Robotics System Toolbox；脚本会给出提示

## 推荐运行方式

1. 解压本文件夹。
2. MATLAB Current Folder 切换到本目录。
3. 先运行：

```matlab
setup_check
```

4. 单独运行某个例子，例如：

```matlab
demo09_coordinate_chain_camera_base
```

5. 或连续运行全部例子：

```matlab
run_all_demos
```

`run_all_demos` 默认逐个运行并在命令行提示，可直接关闭某个图窗继续。

## 目录

- `demos/`：课堂演示函数
- `helpers/`：旋转矩阵、齐次变换、坐标系绘图等辅助函数
- `LECTURE_MAP.md`：课件页码与脚本对应关系

## 关键约定

本包采用课件同一记号思想：

- `T_AB` 在代码中通常表示“把 B 系表达转换到 A 系”的齐次变换（即课件中的 \(T_B^A\)）
- 列向量约定
- 组合从右到左作用，例如 `T_AC = T_AB*T_BC`
- 角度输入统一用弧度；展示时常用 `rad2deg`
- 长度默认单位为 m

