# 实验一 ROS 2 Humble 安装脚本

适配 Ubuntu 22.04 LTS 的 AMD64 / ARM64。教师讲解演示 30 分钟，下载和安装由学生在实操时间完成。VMware 和 Ubuntu 须事先安装；本脚本在 Ubuntu 内执行。

## 使用方法

把 install_ros2_humble.sh 放到 Ubuntu 的下载目录，在该目录打开终端：

```bash
chmod +x install_ros2_humble.sh
./install_ros2_humble.sh --with-vscode
source /opt/ros/humble/setup.bash
```

不安装 VS Code：省略 `--with-vscode`。也可直接 `bash install_ros2_humble.sh`，无需 chmod。不要用 sudo 运行整个脚本；执行中会按需请求密码。不要使用 chmod 777，也不要递归修改目录权限。

脚本更新 Ubuntu 软件包，启用 Universe，安装官方 ROS 软件源、Humble Desktop、示例及开发工具；生成 UTF-8 locale，备份并按需添加 ~/.bashrc 环境配置，创建 ~/ros2_ws/src 和 ~/course_ws/src，初始化 rosdep。它不会安装后续课程的 Gazebo/MoveIt，不会编译空工作空间。下载需访问 Ubuntu、ROS、GitHub；VS Code 还需访问微软服务器。

日志位于 ~/course_materials/install-*.log。失败会立即停止并显示行号；修复错误后可以重新运行。已有损坏的软件源需先按日志排查，脚本不删除旧源或忽略签名错误。

## 单独安装 VS Code

使用官方 Snap 命令（与脚本中的 deb 安装方式二选一）：

```bash
sudo snap install --classic code
code ~/ros2_ws
```

脚本的 `--with-vscode` 使用微软官方 deb 安装包，按架构选择并开启微软 APT 更新源。

## 报告配套验收

任务一：截图 `lsb_release -a`、`dpkg --print-architecture`、`printenv ROS_DISTRO`、`ros2 --help`；练习 pwd、ls、cd、mkdir。

任务二：打开三个终端，均执行 `source /opt/ros/humble/setup.bash`。A 执行 `ros2 run demo_nodes_cpp talker`；B 执行 `ros2 run demo_nodes_py listener`；C 执行 `ros2 node list`、`ros2 topic list`、`ros2 topic info /chatter`、`ros2 topic echo /chatter`。截图后 Ctrl+C 停止，观察停止发布者后的现象。

验证范围：发布前进行了 Bash 语法与参数/平台保护检查。未在真实 Ubuntu 虚拟机中完成全量安装和通信测试；教师应先用课程虚拟机试装。

官方参考：
- https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html
- https://github.com/ros-infrastructure/ros-apt-source/releases/tag/1.3.0
- https://code.visualstudio.com/docs/setup/linux
