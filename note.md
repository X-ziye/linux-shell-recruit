# Linux Shell 任务知识点（01题）
> 本次用到 + 少量延伸

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
```
