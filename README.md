# tc32 编译工具链及 Linux 版 IDE

## 工具链
本 GIT 仓库的三个分支 `linux` 、 `windows` 和 `macos` 分别对应三个操作系统的工具链。

## Linux 版 Telink IDE
在终端中运行

    ./TelinkIde.sh

即可打开该基于 Eclipse 的 IDE ，从而避免操作系统中安装的 java 版本不是 8 导致的启动失败。

注：如果是双击 `TelinkIde.sh` 打开 IDE 的话，编译时会报错说找不到工具链。

## Telink SDK 中的 `tl_check_fw.sh`
Linux 版 IDE 的优点：编译速度飞快，而 Windows 版爆慢，特别是 clean 后重新编译时（修改了 `.h` 文件后都是需要 clean 的）。

Linux 版 IDE 的缺点：如果不临时注释掉 `vendor/common/ble_ll_ota.c` 中的 `err_flg = OTA_FW_CHECK_ERR` 那一行，那么烧录进某 Telink 设备之后，后续对该 Telink 设备进行 OTA 时进度到 10% 左右就会失败。

这个缺点的解决方法是针对 `tl_check_fw.sh` 打如下补丁：
```
+# On all modern variants of Windows (including Cygwin and Wine)
+# the OS environment variable is defined to 'Windows_NT'
+if [ 777${OS} = 777"Windows_NT" ]; then
 ../tl_auth_check_fw.exe  $1.bin  1  0  $2.elf
+else
+# 由于在 Linux 上无法通过 wine 来运行 tl_auth_check_fw.exe ，所以这里通过 ssh 到 Windows 上的方式来运行，
+# 需要提前在 win_server 所示的 Win10 （WinXP 无法运行 tl_auth_check_fw.exe ）上[安装 OpenSSH]
+# (https://github.com/flyskywhy/g/blob/master/i%E4%B8%BB%E8%A7%82%E7%9A%84%E4%BD%93%E9%AA%8C%E6%96%B9%E5%BC%8F/t%E5%BF%AB%E4%B9%90%E7%9A%84%E4%BD%93%E9%AA%8C/%E7%94%B5%E4%BF%A1/Os/Windows/%E5%AE%89%E8%A3%85OpenSSH.md)
+win_server=YOUR_LOGIN_NAME@192.168.19.49
+
+# 这个 tl_auth_check_fw.exe 提前手动复制过一次后，没必要在这里每次自动复制
+# scp tl_auth_check_fw.exe $win_server:temp/
+
+scp $1.bin $win_server:temp/
+scp $2.elf $win_server:temp/
+ssh $win_server "cd temp && tl_auth_check_fw.exe $1.bin 1 0 $2.elf"
+scp $win_server:temp/$1.bin ./
+fi
+
```
