wapi = require("./_wapi.coffee")
fs = require('fs')

_rule = (func)->
    wapi.get(
        ".settings/rules", (error, res, body)->
            func JSON.stringify(
                JSON.parse(body)
                null
                4
            )
    )

cwd = process.cwd()

rpush = ->
    rule = require("#{cwd}/wdog_rules.coffee")
    wapi.put(
        ".settings/rules"
        JSON.stringify(rule, null, 2).replace(/"\_write"/g,"\".write\"").replace(/"\_read"/g,"\".read\"").replace(/"\_validate"/g,"\".validate\"").replace(/"\_indexOn"/g,"\".indexOn\"")
        (error, res, body)->
            console.log body
    )
    0
yargs = require('yargs')
argv = yargs
.command(
    'rulepush',
    "可简写为rp，上传读写权限 ，源文件 当前目录/wdog_rules.coffee",
    rpush
)
.command('rp', false, rpush)
.command(
    'rulepull',
    "下载读写权限到 当前目录/wdog_rules.coffee",
    ->
        _rule (o) ->
            fs.open(
                "#{cwd}//wdog_rules.coffee"
                "w"
                (e,fd) ->
                    if e
                        throw e
                    fs.write(
                        fd
                        "module.exports = \\\n" + o
                        0,'utf8'
                        (e)->
                            if e
                                throw e
                            fs.closeSync(fd)
                    )
            )

        0
)
.command(
    'rule',
    '显示线上的读写权限',
    ->
        _rule (o) ->
            console.log o
        0
)
.help('h')
.alias('h', 'help')
.epilog("当前目录 #{cwd}\n\n更多信息参见 http://wilddog.com")
.recommendCommands()
.argv

if not argv._.length
    yargs.showHelp()
