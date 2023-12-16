# `zotero` and `ZotFile`

为什么要用它俩?

Pros:

* 软件本身只同步 metadata, 速度快
* 导入 PDF 时自动分析 metadata
* 可以用 DOI 或 PMID 新建记录
* 自动重命名文件, 相关文献在同一个子目录里, 方便管理

Cons:

* 不同出版社的 PDF 中的 metadata 格式并不一致; 写文章时要去 Web of Science 重新查
* 与 Word 整合得一般, 文献样式不太全, 写文章时可能得换到 Endnote

## 安装

```shell
# mac
brew install zotero

# Windows
winget install -e --id DigitalScholar.Zotero

# the ZotFile plugin
curl -LO https://github.com/jlegewie/zotfile/releases/download/v5.1.0/zotfile-5.1.0-fx.xpi

```

## 登录

* 去 zotero [官网](https://www.zotero.org/) 注册个账号
* `Preference -> Sync` 登录注册的账号, 以后就可以点主界面右上的绿色按钮同步了
* `Preference -> Advanced`
    * `General` 设置语言为 English, 中文有时会出现奇怪的问题
    * `Files and Folders`
        * `Linked... -> Base directory` 设置到你要放文献的目录, 我放到同步网盘里 `iCloudDrive/zotero`
        * `Data Directory Location` 不用管, 由自动同步处理

## 导入 PDF

* 对于每个主题或课题, 在主界面左侧建一个 collection
* 点击这个 collection, 将 PDF 从文件管理器拖到主界面中间空白的地方; 或者将 PDF 拖到 collection 名字上
* 这时右上角同步按钮边上会出现一个 PDF 图标, 表明 zotero 在自动获取 metadata
* 等几秒, 刚拖进来的 PDF 就会被归化到一条记录下面了, 对于近十几年的 PDF, 一般都能自动获取成功
* 如果不行, 例如书中的章节等, 可以点魔杖按钮, 用 DOI 或 PMID 新建记录, 再将 PDF 拖进去
* 中间栏显示的是记录信息, 最上面右侧一个小按钮可以来调整显示的项目
  * `Publication`, `Year`, `Creator`, `Title`, `Date Added`, and `Attachments`
* 有的记录里会用 `<i>...</i>` 表示斜体, 不太好看, 可以手动修改记录
* 双击记录, 会打开 PDF; 右键点记录, `show file`, 会打开 PDF 所在的目录
* 要删除记录, 不要按 `Delete`, 这只是从 Collection 移除. 右键点记录, `Move item to Trash`
* 但是有两个**问题**, 可以用下面的插件解决
    * 一个记录占了一个子目录, 在没有 zotero 时找文件不方便
    * 同步一大堆 PDF 很慢, 如果它占用了太多的空间, zotero 要收费

## ZotFile

* `Tools -> Add-ons -> 右上角的齿轮按钮 Tools for all Add-ons -> Install Add-on From File`
* 重新运行 zotero

设置 ZotFile `Tools -> ZotFile Preferences`

* `General Settings`
    * ZotFile 可以监控新下载的文件并导入 zotero, 如果想用这个功能, 就设置下 `Source Folder...`. 这个功能过于灵敏, 我一般不用
    * `Location of Files -> Custom Location` 是保存 PDF 的地方, `iCloudDrive/zotero`
    * `Use subfolder...` `/%c`
* `Tablet Settings` 空着
* `Renaming Rules`
    * `Format for all Item...` 设为 `{%s|%j}{ - %y}{ - %a}{ - %t}`
    * Untick `Add user...`, `Change to...`, and `Replace blanks`
    * Tick `Truncate title...`
    * `Maximum length of title` 40
    * `Maximum number of authors` 1
    * Untick `Add suffix...`
* `Advanced Settings`
    * Tick `Remove special...`

回到 zotero, 右键点刚新建的记录 (可以选多个), `Manage Attachments -> Rename and move`. ZotFile
会将文件移动到 `iCloudDrive/zotero/collection_XXX`, 在记录下留下链接.

这样手机或其它设备不用装专门的程序, 一个 collection 占一个子目录, 可以方便地找到文献.
