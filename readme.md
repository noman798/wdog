命令行输入 `wdog` ，即可看到帮助提示

wdog rp 可以部署新的规则，规则wdog_rules.coffee是一个coffeescript文件，可以使用变量。
比如：

```
GROUP_ADMIN = "root.child('group').child('auth.uid').val() == true"

GROUP_ADMIN_RW = "#{GROUP_ADMIN} || (!root.hasChildren(['group','admin']))"

module.exports = \
{
    rules: {
        ".read": true,
        ".write": true,
        group:
            admin: {
                ".read": GROUP_ADMIN_RW
                ".write": GROUP_ADMIN_RW
                ".validate" : "newData.isNumber() && newData.val().isBoolean()"
            }
    }
}
```
