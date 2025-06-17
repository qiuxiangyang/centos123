#!/bin/bash

server_ip=$(hostname -I)

uptime=$(uptime -p)
uptime_cn=$(echo $uptime | sed 's/up/已运行/; s/hour/时/; s/minutes/分/; s/days/天/; s/months/月/')

show_menu() {
    clear
    local greeting
    greeting=$(get_greeting)
    echo "Linux曹级有钱工具箱"
    echo "服务器IP地址: $server_ip"
    echo "服务器运行时间: $uptime_cn"
    echo "$greeting"  
    echo "1. 系统操作菜单"
    echo "2. 网络操作菜单"
    echo "3. 文件操作菜单"
    echo "4. 其他操作菜单"
    echo "5. 内存操作菜单"
    echo "6. 运维操作菜单" 
    
    echo "q. 退出"
}

system_menu() {
    clear
    echo "=== 系统操作菜单 ==="
    echo "1. 一键重启服务器"
    echo "2. 一键修改密码"
    echo "3. 一键同步上海时间"
    echo "4. 一键修改SSH端口"
    echo "5. 一键修改DNS"
    echo "6. 一键开启/关闭SSH登录"
    echo "7. 一键更新CentOS最新版系统"
    echo "8. 一键更新Ubuntu最新版系统"
    echo "9. 一键更新Debian最新版系统"
    echo "10. 一键更换CentOS yum源"
    echo "11. 一键更换Ubuntu apt源"
    echo "12. 一键更换Debian apt源"
    echo "13. 一键创建子用户或管理员"
    echo "14. 一键查看当前与服务器连接的IP"
    echo "15. 一键修改服务器主机名"
    echo "16. 一键更换CentOS8 stream仓库源"
    echo "17. 一键查看SSH登录成功的IP地址"
    echo "q. 返回上级菜单"
    echo "===================="
}

network_menu() {
    clear
    echo "=== 网络操作菜单 ==="
    echo "1. 一键重启网卡"
    echo "2. 一键开启/关闭Ping"
    echo "3. 一键绑定附加IP"
    echo "4. 一键查看服务器地理位置"
    echo "5. 一键查看服务器IP原生地址"
    echo "6. 一键查看服务器配置信息"
    echo "7. 一键检测服务器是否屏蔽UDP"
    echo "8. 一键VPS的IP映射至独立服务器"
    echo "9. 一键关闭VPS的IP映射"
    echo "10. 一键开启四层端口转发"
    echo "11. 一键关闭四层端口转发"
    echo "12. 一键查看服务器在使用的端口"
    echo "13. 一键查看什么IP在跑带宽"
    echo "q. 返回上级菜单"
    echo "===================="
}

file_transfer_menu() {
    clear
    echo "=== 文件传输菜单 ==="
    echo "1. 一键上传文件到远程服务器"
    echo "2. 一键从远程服务器下载文件"
    echo "3. 一键查看所有硬盘分区信息(挂载硬盘前建议查看)"
    echo "4. 一键自定义挂载数据盘"
    echo "5. 一键自定义卸载数据盘"
    echo "6. 一键自定义格式化数据盘"
    echo "7. 一键修复硬盘分区超级坏块"
    echo "8. 一键设置开机启动脚本"
    echo "9. 一键查询关键词文件内容(可用于审查违规)"
    echo "10. 一键查看SSH历史输入命令"
    echo "11. 一键清空SSH历史输入命令"
    echo "q. 返回上级菜单"
    echo "===================="
}

system_maintenance_menu() {
    clear
    echo "======================================================="
    echo "                    系统运维菜单                        "
    echo "======================================================="
    echo "1. 关闭防火墙和安全组"
    echo "2. 删除当前YUM源"
    echo "3. 配置YUM源"
    echo "4. 配置静态IP"
    echo "5. 安装常用软件"
    echo "6. 一键安装Docker"
    echo "7. 一键配置docker加速器"
    echo "8. 一键安装Nginx"
    echo "9. 系统监控"
    echo "10. 一键安装Mysql5.7"
    echo "q. 返回上级菜单"
    echo "======================================================="
}

get_greeting() {
    local hour=$(date +"%H")
    case $hour in
        1|2|3|4|5|6|7|8|9|10|11)
            echo "上午好！欢迎使用曹级有钱工具箱"
            ;;
        12|13|14|15|16|17|18)
            echo "下午好！欢迎使用曹级有钱工具箱"
            ;;
         *)
            echo "晚上好！欢迎使用曹级有钱工具箱"
            ;;
    esac
}

start_iftop() {
    echo "启动 iftop，按 CTRL+C 退出..."
    sudo iftop
}

check_and_install_iftop() {
    if ! command -v iftop &> /dev/null; then
        echo -e "${GREEN}正在检查 iftop 是否已安装...${NC}"
        if [ -f /etc/debian_version ]; then
            echo -e "${GREEN}检测到 Debian/Ubuntu 系统，正在安装 iftop...${NC}"
              sudo apt-get update && sudo apt-get install -y iftop
        elif [ -f /etc/centos-release ]; then
            echo -e "${GREEN}检测到 CentOS 系统，正在安装 iftop...${NC}"
            sudo yum install -y epel-release
            sudo yum install -y iftop
        else
            echo -e "${RED}不支持的系统，无法安装 iftop。${NC}"
        fi
    fi
}

view_history() {
    echo "查看历史记录..."
    if [ -f ~/.bash_history ]; then
        cat ~/.bash_history
    else
        echo "没有找到历史记录文件。"
    fi
    exit 0
}

clear_history() {
    sed -i '' 1d ~/.bash_history
    echo "" > ~/.bash_history
    echo "sed：已经读取 1d："
    echo "历史记录已清空。"
}

install_dig() {
    echo "正在检查 dig 命令..."
    if ! command -v dig &> /dev/null; then
        echo "dig 命令未找到，正在安装..."
        case $(uname -s) in
            Linux)
                if [ -x "$(command -v apt-get)" ]; then
                    sudo apt-get update && sudo apt-get install -y dnsutils
                elif [ -x "$(command -v yum)" ]; then
                    sudo yum install bind-utils
                elif [ -x "$(command -v dnf)" ]; then
                    sudo dnf install bind-utils
                else
                    echo "不支持的Linux发行版"
                    exit 1
                fi
                ;;
            *)
                echo "不支持的操作系统"
                exit 1
                ;;
        esac
    else
        echo "dig 命令已安装."
    fi
}

check_dns_udp() {
    echo "正在测试8.8.8.8的UDP DNS解析..."
    if dig @8.8.8.8 -p 53 google.com > /dev/null; then
        echo "8.8.8.8的UDP DNS解析正常 UDP正常。"
    else
        echo "8.8.8.8的UDP DNS解析失败 UDP屏蔽。"
    fi
}

update_repo() {
    echo "正在更新YUM仓库源到阿里云镜像..."
    sed -e "s|^mirrorlist=|#mirrorlist=|g" -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/|baseurl=https://mirrors.aliyun.com/centos-vault/|g" -i.bak /etc/yum.repos.d/CentOS-Stream-*.repo
    yum makecache
    echo "YUM仓库源更新完成。"
}

log_file_path=""
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
        centos)
            log_file_path="/var/log/secure"
            ;;
        ubuntu|debian)
            log_file_path="/var/log/auth.log"
            ;;
        *)
            echo "不支持的操作系统"
            exit 1
            ;;
    esac
else
    echo "无法检测到操作系统"
    exit 1
fi

show_login_ips() {
    grep 'sshd.*Accepted' "$log_file_path" | awk '{print $11}' | sort | uniq
}

repair_badblocks() {
    read -p "请输入要修复坏块的硬盘分区（例如：/dev/home）：" partition
    echo "开始修复硬盘分区坏块..."
    xfs_repair $partition -L
    echo "修复完成！"
}

review_files_custom() {
    echo "请输入要搜索的目录路径："
    read directory_path
    if [ -d "$directory_path" ]; then
        echo "请输入关键词："
        read keyword
        echo "开始搜索关键词 '$keyword' 在目录 '$directory_path' 中..."
        grep -rl "$keyword" "$directory_path"
    else
        echo "输入的路径不是有效的目录，请重新输入。"
    fi
}

change_hostname() {
    local new_hostname
    read -p "请输入新的主机名：" new_hostname
    if [ -n "$new_hostname" ]; then
        sudo hostnamectl set-hostname "$new_hostname"
        if [ $? -eq 0 ]; then
            echo "主机名已成功修改为：$new_hostname"
        else
            echo "修改主机名失败，请检查输入是否有误。"
        fi
    else
        echo "输入的主机名不能为空。"
    fi
}

disable_selinux() {
    sestatus=$(sestatus | awk '{print $3}')
    if [[ $sestatus == "enabled" ]]; then
        echo "当前 SELinux 状态为已启用。"
        echo "正在关闭 SELinux..."
        setenforce 0
        if [[ $(sestatus | awk '{print $3}') == "disabled" ]]; then
            echo "SELinux 已成功禁用。"
        else
            echo "无法禁用 SELinux。"
        fi
    else
        echo "当前 SELinux 状态为已禁用。"
    fi
}

forwarding() {
    echo "请输入转发端口："
    read source_port
    echo "请输入目标端口："
    read destination_port
    echo "正在进行四层转发，转发端口为 $source_port，目标端口为 $destination_port ..."
    iptables -t nat -A PREROUTING -p tcp --dport $source_port -j DNAT --to-destination 目标IP:$destination_port
    echo "转发已完成！"
}

custom_script() {
    read -p "请输入自定义脚本的内容: " script_content
    home_dir=$(eval echo ~$USER)
    echo "$script_content" > "$home_dir/my.sh"
    chmod +x "$home_dir/my.sh"
    echo "自定义脚本已保存为 my.sh。"
}

disable_forwarding() {
    echo "正在关闭四层转发..."
    iptables -t nat -F
    echo "四层转发已关闭！"
}

check_ip_forwarding() {
    if grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
        echo "net.ipv4.ip_forward=1 已经在 /etc/sysctl.conf 中取消注释"
    else
        echo "net.ipv4.ip_forward=1 未在 /etc/sysctl.conf 中取消注释"
        echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p
        echo "已添加 net.ipv4.ip_forward=1 并重新加载sysctl配置"
    fi
}

close_port_forwarding() {
    sudo iptables -t nat -F
    echo "IP映射已成功关闭"
}

setup_port_forwarding() {
    read -p "请输入VPS的IP地址: " vps_ip
    read -p "请输入VPS上要转发的端口: " vps_port
    read -p "请输入独立服务器的IP地址: " server_ip
    read -p "请输入独立服务器上要映射到的端口: " server_port
    iptables -t nat -A PREROUTING -p tcp --dport $vps_port -j DNAT --to-destination $server_ip:$server_port
    iptables -t nat -A POSTROUTING -p tcp -d $server_ip --dport $server_port -j SNAT --to-source $vps_ip
    echo "端口转发设置成功: $vps_ip:$vps_port -> $server_ip:$server_port"
}

mount_data_disk() {
    read -p "请输入数据盘设备名[默认：/dev/vdb1]: " disk_device
    disk_device=${disk_device:-"/dev/vdb1"}
    read -p "请输入挂载点目录[默认：/data]: " mount_point
    mount_point=${mount_point:-"/data"}
    if [ ! -d "$mount_point" ]; then
        sudo mkdir "$mount_point"
    fi
    if grep -qs "$disk_device" /proc/mounts; then
        echo "数据盘 $disk_device 已经被挂载"
        return
    fi
    if [ ! -e "$disk_device" ]; then
        echo "数据盘 $disk_device 不存在"
        return
    fi
    sudo mount "$disk_device" "$mount_point"
    echo "数据盘 $disk_device 成功挂载到 $mount_point"
    echo "$mount_path $mount_point ext4 defaults 0 2" | sudo tee -a /etc/fstab
    echo "数据盘已成功挂载到 $mount_point，并已设置为开机自动挂载。"
}

install_netstat() {
    if ! command -v netstat &> /dev/null; then
        echo "netstat 未安装，正在尝试安装..."
        if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
            apt-get update && apt-get install -y net-tools
        elif [[ "$ID" == "centos" || "$ID" == "rhel" ]]; then
            yum install -y net-tools
        else
            echo "不支持的操作系统"
            exit 1
        fi
    fi
}

show_connected_ips_count() {
    install_netstat
    netstat -tn | awk '{print $5}' | grep -v 'Address' | cut -d: -f1 | sort | uniq -c | sort -nr
}

function toggle_ssh() {
    if [[ -f /etc/redhat-release ]]; then
        if sudo systemctl is-active --quiet sshd; then
            sudo systemctl stop sshd
            sudo systemctl disable sshd
            echo "SSH登录已禁用"
        else
            sudo systemctl enable sshd
            sudo systemctl start sshd
            echo "SSH登录已启用"
        fi
    elif [[ -f /etc/lsb-release ]]; then
        if sudo service ssh status | grep "running" >/dev/null; then
            sudo service ssh stop
            sudo systemctl disable ssh
            echo "SSH登录已禁用"
        else
            sudo systemctl enable ssh
            sudo service ssh start
            echo "SSH登录已启用"
        fi
    elif [[ -f /etc/debian_version ]]; then
        if sudo service ssh status | grep "running" >/dev/null; then
            sudo service ssh stop
            sudo systemctl disable ssh
            echo "SSH登录已禁用"
        else
            sudo systemctl enable ssh
            sudo service ssh start
            echo "SSH登录已启用"
        fi
    else
        echo "不支持的操作系统"
    fi
}

function disable_swap() {
    if [[ -f /etc/fstab ]]; then
        sudo sed -i '/swap/d' /etc/fstab
        sudo swapoff -a
        echo "SWAP已关闭"
    else
        echo "无法找到fstab文件"
    fi
}

umount_data_disk() {
    read -p "请输入挂载点目录[默认：/data]: " mount_point
    mount_point=${mount_point:-"/data"}
    if [ ! -d "$mount_point" ]; then
        echo "挂载点目录 $mount_point 不存在"
        return
    fi
    if ! grep -qs "$mount_point" /proc/mounts; then
        echo "挂载点目录 $mount_point 未被挂载"
        return
    fi
    sudo umount "$mount_point"
    echo "数据盘 $mount_point 成功卸载"
}

create_user() {
    read -p "请输入要创建的用户名: " username
    if id "$username" &>/dev/null; then
        echo "用户 $username 已存在"
    else
        sudo useradd -m $username
        if [ $? -eq 0 ]; then
            echo "用户 $username 创建成功"
            sudo passwd $username
            read -p "是否要将用户 $username 设置为管理员(y/n): " add_sudo
            if [ "$add_sudo" == "y" ]; then
                sudo usermod -aG wheel $username
                echo "用户 $username 已设置为管理员"
            fi
        else
            echo "创建用户 $username 失败"
        fi
    fi
}

add_ip() {
    read -p "请输入要添加的IP地址：" ip
    read -p "请输入网关：" gateway
    read -p "请输入掩码：" netmask
    if ip addr show | grep -q $ip; then
        echo "IP地址已经存在，删除已存在的IP地址。"
        ip addr del $ip/$netmask dev eth0
    fi
    ip addr add $ip/$netmask dev eth0
    ip route add default via $gateway
    echo "IP地址添加成功。"
    echo "ip addr add $ip/$netmask dev eth0" >> /etc/rc.local
    echo "ip route add default via $gateway" >> /etc/rc.local
    echo "如果IP地址没有立即生效，请尝试重启网卡或重启服务器。"
}

format_disk() {
    read -p "请输入要格式化的数据硬盘设备名称（回车默认/dev/vdb1）：" disk_name
    disk_name=${disk_name:-/dev/vdb1}
    if [ ! -b "$disk_name" ]; then
        echo "硬盘 $disk_name 不存在或不可用。"
        exit 1
    fi
    read -p "请输入文件系统类型（回车默认ext4）：" fs_type
    fs_type=${fs_type:-ext4}
    read -p "您确定要格式化硬盘 $disk_name 为文件系统 $fs_type 吗？(y/n)：" confirm
    if [ "$confirm" != "y" ]; then
        echo "取消操作。"
        exit 0
    fi
    sudo mkfs.$fs_type $disk_name
    if [ $? -eq 0 ]; then
        echo "硬盘 $disk_name 成功格式化为文件系统 $fs_type。"
    else
        echo "无法格式化硬盘 $disk_name。"
    fi
}

function set_swap() {
    read -p "请输入SWAP大小（单位：GB）: " swap_size
    if [[ ! $swap_size =~ ^[0-9]+$ ]]; then
        echo "无效的输入，请输入一个有效的数字"
        return
    fi
    if [[ -f /etc/fstab ]]; then
        sudo sed -i '/swap/d' /etc/fstab
        sudo swapoff -a
        if [[ -f /swapfile ]]; then
            sudo rm /swapfile
        fi
        sudo fallocate -l ${swap_size}G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab
        echo "SWAP已设置为 ${swap_size}GB"
        echo "SWAP设置已添加到 /etc/fstab，将在系统启动时自动启用"
    else
        echo "无法找到fstab文件"
    fi
}

function enable_nested_virtualization() {
    if [[ -f /sys/module/kvm_intel/parameters/nested ]]; then
        sudo modprobe -r kvm_intel
        sudo modprobe kvm_intel nested=1
        echo "已开启虚拟化"
    elif [[ -f /sys/module/kvm_amd/parameters/nested ]]; then
        sudo modprobe -r kvm_amd
        sudo modprobe kvm_amd nested=1
        echo "已开启虚拟化"
    else
        echo "不支持的处理器"
    fi
}

restart_server() {
    read -p "确认要重启服务器吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在重启服务器..."
        sudo reboot
    else
        echo "取消重启服务器"
    fi
}

change_password() {
    username=$(whoami)
    sudo passwd "$username"
    echo "密码已成功修改。"
}

show_server_location() {
    curl ipinfo.io
}

show_server_location2() {
    curl iplark.com
}

sync_shanghai_time() {
    install_ntpdate
    echo "正在同步上海时间..."
    sudo timedatectl set-timezone Asia/Shanghai
    sudo ntpdate cn.pool.ntp.org
    echo "时间同步完成。"
}

change_ssh_port() {
    read -p "请输入新的 SSH 端口: " new_port
    sed -i "s/Port [0-9]*/Port $new_port/" /etc/ssh/sshd_config
    systemctl restart sshd
    echo "SSH 端口已修改为 $new_port"
}

function set_dns() {
    read -p "请输入新的DNS服务器地址: " dns_server
    if [[ -f /etc/redhat-release ]]; then
        echo "nameserver $dns_server" | sudo tee /etc/resolv.conf >/dev/null
        echo "DNS服务器已修改为 $dns_server"
    elif [[ -f /etc/lsb-release ]]; then
        sudo sed -i "s/nameserver .*/nameserver $dns_server/" /etc/resolv.conf
        echo "DNS服务器已修改为 $dns_server"
    elif [[ -f /etc/debian_version ]]; then
        sudo sed -i "s/nameserver .*/nameserver $dns_server/" /etc/resolv.conf
        echo "DNS服务器已修改为 $dns_server"
    else
        echo "不支持的操作系统"
    fi
}

update_centos() {
    read -p "确认要更新 CentOS 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 CentOS 最新版系统..."
        sudo yum update
        echo "CentOS 最新版系统更新完成"
        reboot
    else
        echo "取消更新 CentOS 最新版系统"
    fi
}

update_ubuntu() {
    read -p "确认要更新 Ubuntu 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 Ubuntu 最新版系统..."
        sudo apt update
        sudo apt upgrade -y
        echo "Ubuntu 最新版系统更新完成"
        reboot
    else
        echo "取消更新 Ubuntu 最新版系统"
    fi
}

function toggle_ksm() {
    ksm_status=$(cat /sys/kernel/mm/ksm/run)
    if [ $ksm_status -eq 0 ]; then
        /bin/systemctl start ksm
        /bin/systemctl start ksmtuned
        cat /sys/kernel/mm/ksm/run
        echo "KSM内存回收已开启。"
    else
        /bin/systemctl stop ksmtuned
        /bin/systemctl stop ksm
        echo 0 > /sys/kernel/mm/ksm/run
        echo "KSM内存回收已关闭。"
    fi
}

update_debian() {
    read -p "确认要更新 Debian 最新版系统吗？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        echo "正在更新 Debian 最新版系统..."
        sudo apt update
        sudo apt upgrade -y
        echo "Debian 最新版系统更新完成"
        reboot
    else
        echo "取消更新 Debian 最新版系统"
    fi
}

change_centos_to_aliyun() {
    if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
        echo "正在更换CentOS的源为阿里云源..."
        sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
        cat << 'EOF' | sudo tee /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates - 阿里云镜像
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
EOF
        sudo yum clean all
        sudo yum makecache
        echo "CentOS源更换完成。"
    else
        echo "CentOS源配置文件不存在。"
    fi
}

change_ubuntu_to_aliyun() {
    if [ -f /etc/apt/sources.list ]; then
        echo "正在更换Ubuntu的源为阿里云源..."
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
        sudo sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
        echo "Ubuntu源更换完成。"
    else
        echo "Ubuntu源配置文件不存在。"
    fi
}

change_debian_to_aliyun() {
    if [ -f /etc/apt/sources.list ]; then
        echo "正在更换Debian的源为阿里云源..."
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        sudo sed -i 's|http://[^ ]*|http://mirrors.aliyun.com|' /etc/apt/sources.list
        echo "Debian源更换完成。"
    else
        echo "Debian源配置文件不存在。"
    fi
}

install_ntpdate() {
    if ! command -v ntpdate &> /dev/null; then
        echo "正在安装ntpdate..."
        if [ -f /etc/redhat-release ]; then
            sudo yum install -y ntpdate
        elif [ -f /etc/debian_version ]; then
            sudo apt-get install -y ntpdate
        else
            echo "不支持的操作系统类型。"
            exit 1
        fi
        echo "ntpdate安装完成。"
    fi
}

show_server_config() {
    echo "=== 服务器配置信息 ==="
    echo "CPU核心数:"
    lscpu | grep -w "CPU(s):" | grep -v "\-"
    lscpu | grep -w "Model name:"
    echo "CPU频率:"
    lscpu | grep -w "CPU MHz"
    echo "虚拟化类型:"
    lscpu | grep -w "Hypervisor vendor:"
   echo "系统版本:"
    if [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "Ubuntu $DISTRIB_RELEASE"
    elif [ -f /etc/debian_version ]; then
        DEBIAN_VERSION=$(cat /etc/debian_version)
        echo "Debian $DEBIAN_VERSION"
    elif [ -f /etc/centos-release ]; then
        CENTOS_VERSION=$(cat /etc/centos-release)
        echo "CentOS $CENTOS_VERSION"
    else
        echo "无法识别的系统类型"
    fi
    echo "内存信息:"
    free -h
    echo "硬盘信息:"
    df -h
}

function restart_network_card() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        os=$ID
    elif [ -f /etc/centos-release ]; then
        os="centos"
    else
        echo "Unsupported operating system."
        return
    fi

    if [ "$os" == "debian" ]; then
        sudo systemctl restart networking
    elif [ "$os" == "ubuntu" ]; then
        sudo systemctl restart networkd-dispatcher
    elif [ "$os" == "centos" ]; then
        sudo service network restart
    else
        echo "Unsupported operating system."
        return
    fi

    echo "网卡已重启"
}

upload_file() {
    read -p "请输入远程服务器的 IP 地址或域名: " remote_server
    read -p "请输入远程服务器的用户名: " remote_user
    read -p "请输入远程服务器的目标路径: " remote_path
    read -p "请输入要传输的本地文件的路径: " local_file
    echo "正在传输文件到远程服务器..."
    scp "$local_file" "$remote_user@$remote_server:$remote_path"
    echo "文件传输完成"
}

download_file() {
    read -p "请输入远程服务器的 IP 地址或域名: " remote_server
    read -p "请输入远程服务器的用户名: " remote_user
    read -p "请输入远程服务器的文件路径: " remote_file
    read -p "请输入本地保存文件的路径: " local_path
    echo "正在从远程服务器下载文件..."
    scp "$remote_user@$remote_server:$remote_file" "$local_path"
    echo "文件下载完成"
}

function toggle_ping() {
    if [ "$(sysctl -n net.ipv4.icmp_echo_ignore_all)" = "1" ]; then
        echo "正在开启Ping..."
        sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0
        echo "已开启Ping。"
    else
        echo "正在关闭Ping..."
        sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
        echo "已关闭Ping。"
    fi
}

ask_reboot() {
    read -p "更新完成，是否重启服务器？(y/n): " confirm
    if [[ $confirm == [yY] ]]; then
        restart_server
    else
        echo "更新完成，服务器未重启"
    fi
}

function disable_firewall() {
    systemctl stop firewalld
    systemctl disable firewalld &>/dev/null
    setenforce 0 &>/dev/null
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    if ! systemctl is-active --quiet firewalld; then
        echo "你已成功关闭防火墙和安全组"
    else
        echo "关闭失败，请重新关闭"
    fi
}

function delete_yum_repos() {
    read -p "确定要删除所有YUM源吗? (y/n)" yn
    if [ "$yn" == "y" ]; then
        rm -rf /etc/yum.repos.d/*.repo
        echo "YUM源已被删除"
    else
        echo "操作取消"
    fi
}

function configure_yum_repos() {
    curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo
    yum makecache fast
    echo "YUM源已配置完成"
}

function configure_static_ip() {
    read -p "请输入网络接口名称 (如 ens33): " interface
    if ! ip link show $interface &> /dev/null; then
        echo "网络接口 $interface 不存在。"
        return
    fi
    read -p "请输入静态 IP 地址 (如 192.168.1.10): " ip_address
    read -p "请输入子网掩码 (如 255.255.255.0): " netmask
    read -p "请输入默认网关 (如 192.168.1.1): " gateway
    read -p "请输入备用 DNS 服务器地址 (如 114.114.114.114): " dns1

    cat > "/etc/sysconfig/network-scripts/ifcfg-$interface" << EOF
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
NAME=$interface
UUID=$(uuidgen)
DEVICE=$interface
ONBOOT=yes
IPADDR=$ip_address
NETMASK=$netmask
GATEWAY=$gateway
DNS1=$dns1
EOF
    systemctl restart network.service
    ip addr show $interface
    echo "静态 IP 地址已成功配置。"
}

function install_common_software() {
    echo "正在安装常用软件..."
    yum install -y wget vim git lrzsz vsftpd net-tools
    if [ $? -eq 0 ]; then
        echo "你已成功安装 wget, vim, git, lrzsz, net-tools 和 vsftpd"
    else
        echo "安装失败，请重新安装"
    fi
}

function install_docker() {
    echo "正在安装 Docker..."
    sudo yum remove -y docker docker-common docker-selinux docker-engine &>/dev/null
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.huaweicloud.com/docker-ce/linux/centos/docker-ce.repo
    sed -i 's+download.docker.com+mirrors.huaweicloud.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
    sudo yum makecache fast -y
    sudo yum install -y docker-ce
    docker --version
    systemctl start docker
    systemctl enable docker
    echo "Docker 已成功安装并启动。"
}

function configure_docker_mirror() {
    echo "正在配置 Docker 加速器..."
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://mirror.aliyuncs.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://2a6bf1988cb6428c877f723ec7530dbc.mirror.swr.myhuaweicloud.com",
        "https://docker.m.daocloud.io",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
        "https://dockerhub.icu",
        "https://docker.registry.cyou",
        "https://docker-cf.registry.cyou",
        "https://dockercf.jsdelivr.fyi",
        "https://docker.jsdelivr.fyi",
        "https://dockertest.jsdelivr.fyi",
        "https://mirror.aliyuncs.com",
        "https://dockerproxy.com",
        "https://mirror.baidubce.com",
        "https://docker.m.daocloud.io",
        "https://docker.nju.edu.cn",
        "https://docker.mirrors.sjtug.sjtu.edu.cn",
        "https://docker.mirrors.ustc.edu.cn",
        "https://mirror.iscas.ac.cn",
        "https://docker.rainbond.cc",
        "https://docker.211678.top",
        "https://docker.1panel.live",
        "https://hub.rat.dev",
        "https://docker.m.daocloud.io",
        "https://do.nark.eu.org",
        "https://dockerpull.com",
        "https://dockerproxy.cn",
        "https://docker.awsl9527.cn"
    ]
}
EOF
    systemctl daemon-reload
    systemctl restart docker
    echo "Docker 加速器已配置完成。"
}

function install_nginx() {
    echo "正在安装 Nginx..."
    read -p "你确定要安装 Nginx 吗？(1确定/2退出)" a
    if [ "$a" -eq 1 ]; then
        yum install -y nginx
        if [ $? -eq 0 ]; then
            echo "Nginx 已安装，正在启动 Nginx 服务..."
            systemctl start nginx
            systemctl enable nginx
            echo "Nginx 已安装并启动"
        else
            echo "Nginx 安装失败，请重新安装"
        fi
    elif [ "$a" -eq 2 ]; then
        echo "程序退出"
    fi
}

function system_monitoring() {
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    RESET='\033[0m'

    LOG_DIR="/var/log/system_maintenance"
    mkdir -p $LOG_DIR
    LOG_FILE="$LOG_DIR/maintenance_$(date +%Y%m%d_%H%M%S).log"

    if [ "$(id -u)" != "0" ]; then
      echo -e "${RED}错误：必须使用root权限运行本脚本${RESET}" | tee -a $LOG_FILE
      exit 1
    fi

    echo -e "\n${BLUE}====== 系统基础信息 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${GREEN}主机名: $HOSTNAME${RESET}"
      echo "系统时间: $(date)"
      echo "运行时间: $(uptime)"
      echo "系统版本: $(cat /etc/redhat-release 2>/dev/null || cat /etc/issue)"
      echo "内核版本: $(uname -r)"
      echo "CPU使用率: $(top -bn1 | grep 'Cpu(s)' | sed 's/.*, *$[0-9.]*$%* id.*/\1/' | awk '{print 100 - $1}')%"
      echo "内存使用: $(free -m | awk '/Mem/{printf "%.2f%", $3/$2*100}')"
      echo "磁盘使用:"
      df -h | grep -vE 'tmpfs|devtmpfs' | sed 's/^/  /'
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 内核参数检查 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${YELLOW}当前生效参数:${RESET}"
      sysctl -a | grep -E 'net.ipv4.ip_forward|fs.file-max|net.core.somaxconn'
      echo -e "\n${YELLOW}配置文件差异检查:${RESET}"
      grep -E '^net.ipv4.ip_forward|^fs.file-max|^net.core.somaxconn' /etc/sysctl.conf
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 防火墙状态 ======${RESET}" | tee -a $LOG_FILE
    {
      firewall-cmd --state 2>&1
      echo -e "\n${YELLOW}开放端口:${RESET}"
      firewall-cmd --list-ports
      echo -e "\n${YELLOW}开放服务:${RESET}"
      firewall-cmd --list-services
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 网络状态检查 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${YELLOW}IP地址信息:${RESET}"
      ip addr show | grep 'inet ' | grep -v '127.0.0.1'
      echo -e "\n${YELLOW}路由表:${RESET}"
      ip route
      echo -e "\n${YELLOW}监听端口:${RESET}"
      ss -tulnp | grep -vE '127.0.0.1|::1'
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 服务状态检查 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${YELLOW}关键服务状态:${RESET}"
      systemctl list-units --type=service --state=running | grep -E 'sshd|nginx|httpd|mysql|mariadb|postgresql'
      echo -e "\n${YELLOW}失败服务检测:${RESET}"
      systemctl --failed
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 软件包检查 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${YELLOW}可用更新:${RESET}"
      yum check-update | grep -v '^$'
      echo -e "\n${YELLOW}最近安装的软件包:${RESET}"
      rpm -qa --last | head -20
    } | tee -a $LOG_FILE

    echo -e "\n${BLUE}====== 安全审计 ======${RESET}" | tee -a $LOG_FILE
    {
      echo -e "${YELLOW}SSH登录记录:${RESET}"
      grep 'sshd' /var/log/secure | tail -10
      echo -e "\n${YELLOW}sudo使用记录:${RESET}"
      grep 'sudo:' /var/log/secure | tail -5
    } | tee -a $LOG_FILE

    echo -e "\n${GREEN}检查完成，完整日志请查看：$LOG_FILE${RESET}"
}

function install_mysql57() {
    echo "开始一键部署MySQL 5.7..."
    cat <<EOF > /etc/yum.repos.d/mysql-community.repo
[mysql56-community]
name=MySQL 5.6 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/7/\$basearch/
enabled=0
gpgcheck=0

[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/\$basearch/
enabled=1
gpgcheck=0

[mysql80-community]
name=MySQL 8.0 Community Server
baseurl=http://repo.mysql.com/yum/mysql-8.0-community/el/7/\$basearch/
enabled=0
gpgcheck=0

[mysql-connectors-community]
name=MySQL Connectors Community
baseurl=http://repo.mysql.com/yum/mysql-connectors-community/el/7/\$basearch/
enabled=0
gpgcheck=0
EOF

    echo "已配置MySQL YUM源"
    echo "正在安装MySQL社区版服务器..."
    yum install -y mysql-community-server

    if [ $? -eq 0 ]; then
        echo "MySQL安装成功！"
    else
        echo "MySQL安装失败，请检查网络连接或源配置。"
        exit 1
    fi

    systemctl start mysqld
    systemctl enable mysqld
    echo "MySQL服务已启动，并设置为开机自启"
    temp_pass=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

    if [ -n "$temp_pass" ]; then
        echo "找到临时密码：$temp_pass"
    else
        echo "未找到临时密码，正在进行修复..."
        systemctl stop mysqld
        rm -rf /var/lib/mysql/* && rm -rf /var/log/mysqld.log
        systemctl start mysqld
        temp_pass=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
        if [ -n "$temp_pass" ]; then
            echo "修复后找到的新临时密码：$temp_pass"
        else
            echo "未能生成临时密码，请手动检查。"
            exit 1
        fi
    fi

    echo "请使用以下临时密码登录MySQL，并尽快修改密码：$temp_pass"
    echo "例如：mysql -u root -p'$temp_pass'"
    echo "然后运行 'mysql_secure_installation' 进行安全设置。"
    echo "或者执行 'mysqladmin -u root -p'$temp_pass' password '新密码''"
    echo "MySQL 5.7一键部署完成！"
}

while true
do
    show_menu
    read -p "请输入选项: " choice
    case $choice in
        1)
            while true
            do
                system_menu
                read -p "请输入选项: " system_choice
                case $system_choice in
                    1) restart_server ;;
                    2) change_password ;;
                    3) sync_shanghai_time ;;
                    4) change_ssh_port ;;
                    5) set_dns ;;
                    6) toggle_ssh ;;
                    7) update_centos ;;
                    8) update_ubuntu ;;
                    9) update_debian ;;
                    10) change_centos_to_aliyun ;;
                    11) change_ubuntu_to_aliyun ;;
                    12) change_debian_to_aliyun ;;
                    13) create_user ;;     
                    14) show_connected_ips_count ;;     
                    15) change_hostname ;;   
                    16) update_repo ;;
                    17) show_login_ips ;;
                    q) break ;;
                    *) echo "无效的选项，请重新输入" ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        2)
            while true
            do
                network_menu
                read -p "请输入选项: " network_choice
                case $network_choice in
                    1) restart_network_card ;;
                    2) toggle_ping ;;
                    3) add_ip ;;
                    4) show_server_location ;;
                    5) show_server_location2 ;;    
                    6) show_server_config ;; 
                    7) install_dig
                       check_dns_udp ;;       
                    8) check_ip_forwarding
                       setup_port_forwarding ;;
                    9) close_port_forwarding ;;
                    10) forwarding ;;
                    11) disable_forwarding ;;
                    12) netstat -tuln ;; 
                    13) check_and_install_iftop
                        start_iftop ;;   
                    q) break ;;
                    *) echo "无效的选项，请重新输入" ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        3)
            while true
            do
                file_transfer_menu
                read -p "请输入选项: " file_transfer_choice
                case $file_transfer_choice in
                    1) upload_file ;;
                    2) download_file ;;
                    3) fdisk -l ;;    
                    4) mount_data_disk ;;
                    5) umount_data_disk ;;   
                    6) format_disk ;; 
                    7) repair_badblocks ;;     
                    8) custom_script ;;
                    9) review_files_custom ;;
                    10) view_history ;;
                    11) clear_history ;;
                    q) break ;;
                    *) echo "无效的选项，请重新输入" ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        4)
            while true
            do
                clear
                echo "=== 其他选项菜单 ==="
                echo "1. 一键测试带宽网速"
                echo "2. 一键测试回程路由"
                echo "3. 一键安装CentOS宝塔最新版"
                echo "4. 一键安装Ubuntu宝塔最新版"
                echo "5. 一键安装Debian宝塔最新版"
                echo "6. 一键安装彩虹Kangle最新版"
                echo "7. 一键安装宝塔WAF最新版"
                echo "q. 返回上级菜单"
                echo "===================="
                read -p "请输入选项: " other_choice
                case $other_choice in
                1) bash <(wget -qO- https://down.vpsaff.net/linux/speedtest/superbench.sh) --speed ;;
                2) wget -qO- git.io/besttrace | bash ;;  
                3) yum install -y wget && wget -O install.sh https://download.bt.cn/install/install_6.0.sh && sh install.sh 02f332488 ;; 
                4) wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh 02f332488 ;;    
                5) wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh 02f332488 ;; 
                6) yum -y install wget;wget http://kangle.cccyun.cn/start;sh start ;;    
                7) URL=https://download.bt.cn/cloudwaf/scripts/install_cloudwaf.sh && if [ -f /usr/bin/curl ];then curl -sSO "$URL" ;else wget -O install_cloudwaf.sh "$URL";fi;bash install_cloudwaf.sh ;;    
                q) break ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        5)
            while true
            do
                clear
                echo "=== 内存操作菜单 ==="
                echo "1. 一键开启云服务器虚拟化"
                echo "2. 一键自定义设置SWAP虚拟内存"
                echo "3. 一键关闭SWAP虚拟内存"
                echo "4. 一键开启/关闭KSM内存回收"
                echo "5. 一键关闭SELinux"
                echo "q. 返回上级菜单"
                echo "===================="
                read -p "请输入选项: " other_choice
                case $other_choice in
                1) enable_nested_virtualization ;; 
                2) set_swap ;;  
                3) disable_swap ;;  
                4) toggle_ksm ;;
                5) disable_selinux ;;
                q) break ;;
                *) echo "无效的选项，请重新输入" ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        6)
            while true
            do
                system_maintenance_menu
                read -p "请输入选项: " maintenance_choice
                case $maintenance_choice in
                    1) disable_firewall ;;
                    2) delete_yum_repos ;;
                    3) configure_yum_repos ;;
                    4) configure_static_ip ;;
                    5) install_common_software ;;
                    6) install_docker ;;
                    7) configure_docker_mirror ;;
                    8) install_nginx ;;
                    9) system_monitoring ;;
                    10) install_mysql57 ;;
                    q) break ;;
                    *) echo "无效输入，请输入数字 1-10 中的一个。" ;;
                esac
                read -p "按回车键继续..."
            done
            ;;
        q)
            echo "再见！"
            break
            ;;
        *)
            echo "无效的选项，请重新输入"
            ;;
    esac
    read -p "按回车键继续..."
done