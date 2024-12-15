# `zotero` and `ZotMoov`

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

# the zotmoov plugin
curl -LO https://github.com/wileyyugioh/zotmoov/releases/download/1.2.5/zotmoov-1.2.5-fx.xpi

```

## 登录

* 去 zotero [官网](https://www.zotero.org/) 注册个账号
* `Edit -> Settings -> Sync` 登录注册的账号, 以后就可以点主界面右上的绿色按钮同步了
* `Edit -> Settings -> General`
    * 设置语言为 English, 中文有时会出现奇怪的问题
    * `Customize Filename Format...`
        * 根据是否有期刊缩写, 选择使用出版物标题或期刊缩写, 长度分别限制为 18 个字符
        * 并在后面添加年份和标题，标题长度限制为 40 个字符

```text
{{ if journalAbbreviation == "" }}
{{publicationTitle truncate="18" suffix=" - "}}
{{ else }}
{{journalAbbreviation replaceFrom="\." replaceTo="" regexOpts="g" truncate="18" suffix=" - "}}
{{endif}}
{{ year suffix=" - " }}
{{ title truncate="40" }}

```

* `Edit -> Settings -> Advanced`
    * `Linked Attachment Base Directory` 设置到你要放文献的目录, 我放到同步网盘里 `~/OneDrive - 南京大学/zotero`
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

## ZotMoov

* `Tools -> Plugins -> 右上角的齿轮按钮 -> Install Plugin From File`
* 重新运行 zotero

设置 ZotMoov `Edit -> Settings -> ZotMoov`

* `Directory to Move Files to` 是保存 PDF 的地方, `~/OneDrive - 南京大学/zotero`
* `Other Settings`
    * Tick all
    * `Subdirectory String` 设为 `{%c}`

回到 zotero, 右键点刚新建的记录 (可以选多个), `ZotMoov: Move Selected to Directory`. ZotMoov
会将文件移动到 `~/OneDrive - 南京大学/zotero/collection_XXX`, 在原来的记录下留下链接.

这样手机或其它设备不用装专门的程序, 一个 collection 占一个子目录, 可以方便地找到文献.
