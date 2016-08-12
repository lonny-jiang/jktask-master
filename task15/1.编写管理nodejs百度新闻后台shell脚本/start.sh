# pm2启动监测CPU占用重启PM2
echo "运行开始咯～"

# 利用pm2启动bin目录下的nodejs程序
pm2 start ./bin/www

# 定义cpu占用率最大为98%
maxCpuRate=98

# 不断循环获
while [ true ]

do
    #获取pid，看看node是否存在，不在就退出
    pid=`ps -e|grep '[0-9].node./'|awk '{print $1}'`
    echo '进程号＝'$pid
    if [ ! $pid ]
    then
        echo "没有找到node进程"
        break
    fi

    #当pm2被kill之后，pid为空，复活进程
    if [ $pid＝'' ]
    then
        echo "复活所有进程"
        pm2 restart
        pm2 start ./bin/www
    fi

    # 获取当前CPU占用率
    cpu=`ps -p $pid -o pcpu|grep -v CPU|cut -d . -f 1|awk '{print $1}'`
    echo 'cpu占用率='$cpu'%'
    # cpu占用率超过95%就重启
    if [ "$cpu" -gt "$maxCpuRate" ]
    then
        echo "cpu占用率已大于98%，需要重启！"
        pm2 restart all
    else
        echo "一切尽在掌控之中" 
    fi

    # 每2秒high一次
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    sleep 2s 

done