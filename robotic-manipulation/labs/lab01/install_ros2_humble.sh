#!/usr/bin/env bash
# SZTU 机器人操作 实验一：Ubuntu 22.04 + ROS 2 Humble
# 普通用户执行；仅需要管理权限的操作使用 sudo。
set -Eeuo pipefail

with_vscode=0
for arg in "$@"; do
  case "$arg" in
    --with-vscode) with_vscode=1 ;;
    -h|--help)
      printf '%s\n' '用法：bash install_ros2_humble.sh [--with-vscode]' \
        '仅支持 Ubuntu 22.04 amd64/arm64；在 Ubuntu 虚拟机内以普通用户运行。' \
        '安装 ROS Desktop、开发工具，更新系统软件包，配置 Bash 环境。' \
        '可选安装 VS Code；日志保存在 ~/course_materials/install-*.log。'
      exit 0 ;;
    *) printf '未知参数：%s\n' "$arg" >&2; exit 2 ;;
  esac
done
fail() { printf '\n错误：%s\n' "$*" >&2; exit 1; }
[[ $(uname -s) == Linux && -r /etc/os-release ]] || fail '请在 Ubuntu 虚拟机中运行，不要在 macOS 或 Windows 终端运行。'
source /etc/os-release
[[ ${ID:-} == ubuntu && ${VERSION_ID:-} == 22.04 ]] || fail '本课程要求 Ubuntu 22.04，请勿在其他版本强行安装。'
[[ $EUID -ne 0 ]] || fail '请用普通用户运行，不要使用 sudo bash；脚本会在需要时请求 sudo。'
arch=$(dpkg --print-architecture)
case "$arch" in amd64|arm64) ;; *) fail "不支持的架构：$arch" ;; esac
[[ -z ${ROS_DISTRO:-} || ${ROS_DISTRO} == humble ]] || fail '当前终端已加载其他 ROS 发行版，请使用干净终端。'

mkdir -p "$HOME/course_materials"
log_file="$HOME/course_materials/install-$(date +%Y%m%d-%H%M%S)-$$.log"
exec > >(tee -a "$log_file") 2>&1
trap 'rc=$?; printf "\n安装中断，行号 %s，退出码 %s。日志：%s\n修复网络或软件源问题后可重新运行脚本。\n" "$LINENO" "$rc" "$log_file"; exit "$rc"' ERR
printf 'Ubuntu %s / %s；日志：%s\n' "$VERSION_ID" "$arch" "$log_file"
sudo -v
apt_run() { sudo apt-get -o DPkg::Lock::Timeout=120 -o Acquire::Retries=3 "$@"; }

printf '\n[1/6] 更新 Ubuntu 并准备工具（可能需要较长时间）\n'
apt_run update
# 官方 Humble 安装说明要求先更新系统，避免旧 systemd/udev 依赖问题。
# --no-remove 避免升级或安装时静默移除现有软件包。
apt_run --no-remove upgrade -y
apt_run --no-remove install -y locales curl ca-certificates software-properties-common git python3
sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
sudo add-apt-repository -y universe

printf '\n[2/6] 配置官方 ROS 软件源\n'
download_dir=$(mktemp -d /tmp/ros2-course.XXXXXXXX)
chmod 755 "$download_dir"
if ! dpkg-query -W -f='${Status}' ros2-apt-source 2>/dev/null | grep -q 'install ok installed'; then
  # 固定官方引导包版本与 SHA256；APT 后续负责软件源包更新。
  ros_deb="$download_dir/ros2-apt-source.deb"
  curl --fail --location --retry 3 --connect-timeout 20 \
    https://github.com/ros-infrastructure/ros-apt-source/releases/download/1.3.0/ros2-apt-source_1.3.0.jammy_all.deb \
    --output "$ros_deb"
  printf '%s  %s\n' '110b9a462d55252decb8b7c816f61c2ba0d9890ce5fb93ac504e97cae5860d76' "$ros_deb" | sha256sum -c -
  sudo dpkg -i "$ros_deb"
fi

printf '\n[3/6] 安装 ROS 2 Humble Desktop 和开发工具\n'
apt_run update
apt_run --no-remove install -y ros-humble-desktop ros-dev-tools \
  ros-humble-demo-nodes-cpp ros-humble-demo-nodes-py

printf '\n[4/6] 配置用户环境与目录\n'
source_line='source /opt/ros/humble/setup.bash'
touch "$HOME/.bashrc"
if ! grep -Fqx "$source_line" "$HOME/.bashrc"; then
  cp -p "$HOME/.bashrc" "$HOME/.bashrc.before-ros2-$(date +%Y%m%d-%H%M%S)-$$"
  printf '\n# SZTU ROS 2 Humble\n%s\n' "$source_line" >> "$HOME/.bashrc"
fi
mkdir -p "$HOME/ros2_ws/src" "$HOME/course_ws/src"
# ROS 环境脚本允许未设置变量，暂时关闭 nounset。
set +u
source /opt/ros/humble/setup.bash
set -u
ros2 --help >/dev/null
ros2 pkg prefix demo_nodes_cpp
ros2 pkg prefix demo_nodes_py

printf '\n[5/6] 初始化 rosdep（供后续开发实验使用）\n'
if [[ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]]; then
  sudo rosdep init
fi
rosdep update --rosdistro humble

printf '\n[6/6] 可选 VS Code\n'
if [[ $with_vscode == 1 ]]; then
  # 微软官方 Stable deb，按虚拟机架构选择。
  code_deb="$download_dir/vscode.deb"
  code_arch="$arch"
  [[ "$arch" != amd64 ]] || code_arch=x64
  curl --fail --location --retry 3 --connect-timeout 20 \
    "https://update.code.visualstudio.com/latest/linux-deb-${code_arch}/stable" --output "$code_deb"
  printf 'code code/add-microsoft-repo boolean true\n' | sudo debconf-set-selections
  apt_run --no-remove install -y "$code_deb"
  code --version
else
  printf '本次未安装 VS Code；需要时重运行：bash install_ros2_humble.sh --with-vscode\n'
fi
printf '\n安装检查完成，ROS_DISTRO=%s。下载包保留在 %s。\n' "$ROS_DISTRO" "$download_dir"
printf '%s\n' \
  '请在当前交互终端执行：source /opt/ros/humble/setup.bash' \
  '终端 A：ros2 run demo_nodes_cpp talker' \
  '终端 B：ros2 run demo_nodes_py listener' \
  '终端 C：ros2 node list；ros2 topic list；ros2 topic echo /chatter' \
  '每个终端都要先加载 ROS 环境；按 Ctrl+C 停止。请自行完成通信截图。' \
  '如已安装 VS Code，可执行：code ~/ros2_ws' \
  '本脚本仅验证命令和示例包可用，通信验收需完成上面的课堂实验。'
if [[ -f /var/run/reboot-required ]]; then
  printf '\nUbuntu 提示需要重启，请保存工作后重启虚拟机。\n'
fi
