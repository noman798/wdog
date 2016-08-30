命令行输入 `wdog` ，即可看到帮助提示

wdog rp 可以部署新的规则，规则wdog_rules.coffee是一个coffeescript文件，可以使用变量。
比如：

```
USER_IS_ADMIN = "root.child('group').child('admin').child(auth.uid).val() == true"

GROUP_ADMIN_RW = "#{USER_IS_ADMIN} || (!root.hasChildren(['group','admin']))"


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
        admin_log:{
            ".read": USER_IS_ADMIN
            ".write": USER_IS_ADMIN
        }
    }
}
```
为了少打引号，也可以用类似 _write 替代 ".write" 等等，上传工具会自动处理转换，比如
```
USER_IS_ADMIN = "root.child('group').child('admin').child(auth.uid).val() == true"

GROUP_ADMIN_RW = "#{USER_IS_ADMIN} || (!root.hasChildren(['group','admin']))"

module.exports = \
{
    rules: {
        _read: true,
        _write: true,
        group:
            admin: {
                _read: GROUP_ADMIN_RW
                _write: GROUP_ADMIN_RW
                _validate : "newData.isNumber() && newData.val().isBoolean()"
            }
        admin_log:{
            _read: USER_IS_ADMIN
            _write: USER_IS_ADMIN
        }
    }
}
```
