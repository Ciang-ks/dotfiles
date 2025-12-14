# Dotfiles (个人配置文件)

我的个人配置文件集合。

## 目录结构

- `config/`: 应用程序配置 (例如: mihomo)
- `git/`: Git 配置
- `tmux/`: Tmux 配置
- `vim/`: Vim 配置
- `zsh/`: Zsh 配置

## 安装指南

在新系统上安装这些配置：

1. 克隆此仓库：
   ```bash
   git clone <repository-url>
   cd dotfiles
   ```

2. 运行安装脚本：
   ```bash
   ./install.sh
   ```

脚本将自动执行以下操作：
- 备份现有的配置文件（重命名为 `.backup.时间戳`，防止覆盖）。
- 创建从本仓库到家目录的符号链接。
- **安装 Oh My Zsh**: 配置 Zsh 和 Oh My Zsh。
- **安装 Miniconda**: 安装最新的 Miniconda3（并在 `.zshrc` 中自动配置）。

## 手动配置: Mihomo (代理)

脚本**不会**自动安装或运行 Mihomo。请按照以下步骤手动操作：

1.  **下载 Mihomo**:
    从 [GitHub Releases](https://github.com/MetaCubeX/mihomo/releases) 下载适合你架构的最新版本。
    ```bash
    # Linux AMD64 示例
    wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.17/mihomo-linux-amd64-v1.19.17.gz
    gzip -d mihomo-linux-amd64-v1.19.17.gz
    mv mihomo-linux-amd64-v1.19.17 mihomo
    chmod +x mihomo
    # 如果有 sudo 权限，可以移动到 /usr/local/bin，否则放在 ~/bin 或其他 PATH 路径下
    sudo mv mihomo /usr/local/bin/
    ```

2.  **在 Tmux 中运行 Mihomo**:
    启动一个名为 `proxy` 的后台 tmux 会话来运行 Mihomo。
    ```bash
    tmux new-session -d -s proxy "mihomo -f ~/.config/mihomo/config.yaml"
    ```

3.  **管理代理**:
    - 进入会话: `tmux attach -t proxy`
    - 退出会话 (保持后台运行): 按下 `Ctrl+b` 然后按 `d`
