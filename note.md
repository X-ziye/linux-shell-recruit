# Task01 知识点总结

## 1. 基础目录命令
- `pwd`：print working directory，**打印当前所在的绝对路径**
- `cd`：change directory，切换目录
  - `cd .` 留在当前目录
  - `cd ..` 回到上一级目录
  - `cd ~` 回到家目录
- `ls`：list，列出目录内容
  - `ls -a`：**显示隐藏文件**（以`.`开头的文件/文件夹，例如 `.project`）

## 2. 相对路径 vs 绝对路径
- **绝对路径**：以 `/` 开头，从根目录开始，唯一确定文件位置，如 `/mnt/xxx/workspace/project/metadata`
- **相对路径**：**不以 `/` 开头**，以当前工作目录为基准定位
  - `.`：当前目录
  - `..`：上一级目录
  - 示例：当前在 `workspace/project/utils`，访问 `metadata` 文件
    - 路径：`../../.project/metadata`
    - 第1个`..`：utils → project
    - 第2个`..`：project → workspace
- 验证方法：
```bash
cat ../../.project/metadata
```

## 3. 文件查看命令
```bash
cat filename
```
- `cat`：读取文件并输出全部内容，适合小文件查看

## 4. 查找命令 find & grep
```bash
# find：在目录树里搜索文件/目录
find 搜索起点 -name "匹配名称"

# grep：在文件内容里搜索文本
grep "关键词" filename
```
- `find`：**按文件名找文件**，遍历文件夹树
- `grep`：**按内容匹配**，在文件里面搜文字

## 5. 隐藏文件
- Linux中，**名字以 `.` 开头** 的文件/文件夹就是隐藏文件（例：`.project`、`.gitignore`）
- 默认 `ls` 看不到，必须用 `ls -a` 才能列出

## 6. tr 命令 & 输入重定向
```bash
tr -d '\r\n' < file.txt
```
- `tr -d`：删除指定字符
- `\n` Linux换行(LF)；`\r` Windows回车
- `<` 输入重定向，将文件送入命令
> 校验脚本用它去除换行回车，只比对纯文本。

## 7. LF / CRLF 换行（本次踩坑重点）
- LF `\n`：Linux，shell脚本**必须用LF**
- CRLF `\r\n`：Windows换行，会报 `$'\r': command not found`
- 修复方法
  1. VS Code：右下角 CRLF → LF，保存
  2. 终端：
```bash
sed -i 's/\r$//' check.sh
```

## 8. Shell 脚本执行
```bash
# 推荐，不需要执行权限
bash ./check.sh 01

# 直接执行，需要加可执行权限 chmod +x check.sh
chmod +x check.sh
./check.sh 01
```
- `01` 是传给脚本的参数，选择执行第1题校验函数

## 9. 脚本条件判断 [[ ]]
```bash
[[ "字符串A" == "字符串B" ]] || return 1
```
- `[[ ]]` bash条件判断
- `==` 字符串相等比较
- `|| return 1`：条件失败则返回错误

## 易错清单
1. 相对路径末尾不要随便加 `/`，metadata是文件不是目录
2. sh脚本必须LF换行，Windows粘贴容易引入CRLF
3. 字符串比对：大小写、空格会影响匹配

# Task02 知识点总结
## 1. 两种执行命令的方式
1. `./tools/recruit-info`
- 提供**相对路径**，shell直接按路径定位文件执行。
- **不使用PATH环境变量搜索**。
> `./` 代表当前目录。

2. `recruit-info`（不带路径）
- shell 读取 `PATH` 环境变量，按顺序遍历里面记录的目录，查找同名可执行文件。
- 如果所有目录都找不到 → `command not found`。

## 2. PATH 环境变量
- PATH 是**环境变量**，存储**一长串字符串**。
- 多个目录之间用**冒号 `:`**分隔（Windows 使用分号 `;`）。
- 搜索规则：从左往右依次检索目录，找到第一个匹配的程序就执行。

## 3. 命令解析：`export PATH="$PATH:$(pwd)/tools"`
- `pwd`：打印当前工作目录（print working directory）。
- `$(pwd)`：**命令替换**，执行pwd命令，捕获输出的路径文本。
- `$PATH`：读取PATH变量原来保存的全部目录。
- `:`：目录分隔符，用于拼接多个目录。
- `" "` 双引号：允许内部`$`变量替换，防止空格带来解析错误。
- `export`：将变量导出为**环境变量**，子进程/子脚本可以继承这个变量。

> 效果：**在原有PATH末尾追加项目的tools目录**。
> 仅**当前终端会话生效**，关闭终端后PATH自动恢复原状，不会修改`.bashrc`永久配置，满足题目约束。

### 两种追加顺序区别
1. `PATH="$PATH:新目录"`：新目录放末尾 → 优先搜索系统原有命令
2. `PATH="新目录:$PATH"`：新目录放开头 → 优先搜索新目录内程序

## 4. shell 与终端
- **终端（terminal）**：窗口，负责接收键盘输入、展示输出文本，本身不懂命令。
- **shell（bash）**：命令行解释器，是用户和Linux内核之间的翻译程序。
  读取你输入的命令，解析语法，调用内核完成任务。

## 5. 变量两种类型
1. 普通变量 `VAR=value`：仅当前shell可见，子进程无法读取。
2. 环境变量 `export VAR=value`：当前shell + 后续启动的子进程都可以读取。

## 6. 语法小考点
- `$VAR`：读取变量的值；`${VAR}` 显式界定变量边界，变量后紧跟字母数字时必须使用。
- `$(command)`：命令替换，执行command并捕获输出。
