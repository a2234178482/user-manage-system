#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-17"
export CATALINA_HOME="/opt/tomcat"
export CATALINA_BASE="$(dirname "$0")/tomcat-base"
export MYSQL_USER="root"
export MYSQL_PASS="2234178482"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$PROJECT_DIR/src"
WEB_DIR="$PROJECT_DIR/web"
OUT_DIR="$WEB_DIR/WEB-INF/classes"
LIB_DIR="$WEB_DIR/WEB-INF/lib"
MYSQL_JAR="$LIB_DIR/mysql-connector-java-8.0.28.jar"
TOMCAT_SERVLET="$CATALINA_HOME/lib/servlet-api.jar"
TOMCAT_JSP="$CATALINA_HOME/lib/jsp-api.jar"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_banner() {
    echo "============================================"
    echo "   用户综合管理系统 - 一键部署脚本"
    echo "============================================"
    echo ""
}

compile() {
    echo -e "${YELLOW}[编译]${NC} 正在清理旧的 class 文件..."
    rm -rf "$OUT_DIR"
    mkdir -p "$OUT_DIR"

    echo -e "${YELLOW}[编译]${NC} 正在编译 Java 源文件..."
    find "$SRC_DIR" -name "*.java" > /tmp/sources.txt
    "$JAVA_HOME/bin/javac" -encoding UTF-8 \
        -cp "$MYSQL_JAR:$TOMCAT_SERVLET:$TOMCAT_JSP:$OUT_DIR" \
        -d "$OUT_DIR" \
        @/tmp/sources.txt

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[成功]${NC} 编译完成！"
    else
        echo -e "${RED}[失败]${NC} 编译出错，请检查源代码！"
        exit 1
    fi
}

init_db() {
    echo -e "${YELLOW}[数据库]${NC} 正在初始化数据库..."
    mysql -u "$MYSQL_USER" -p"$MYSQL_PASS" < "$PROJECT_DIR/user.sql" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[成功]${NC} 数据库初始化完成！"
    else
        echo -e "${RED}[失败]${NC} 数据库初始化出错，请检查 MySQL 是否运行！"
    fi
}

start_tomcat() {
    mkdir -p "$CATALINA_BASE/conf/Catalina/localhost"
    mkdir -p "$CATALINA_BASE/logs"
    mkdir -p "$CATALINA_BASE/temp"
    mkdir -p "$CATALINA_BASE/work"

    echo -e "${GREEN}[启动]${NC} Tomcat 已启动！"
    echo "============================================"
    echo "  访问地址: http://localhost:8080/UserManage/"
    echo "  登录账号: admin / admin123"
    echo "============================================"
    "$CATALINA_HOME/bin/catalina.sh" run
}

stop_tomcat() {
    echo -e "${YELLOW}[停止]${NC} 正在停止 Tomcat..."
    "$CATALINA_HOME/bin/catalina.sh" stop
    echo -e "${GREEN}[完成]${NC} Tomcat 已停止"
}

print_banner

case "$1" in
    full)
        compile
        init_db
        start_tomcat
        ;;
    compile)
        compile
        ;;
    db)
        init_db
        ;;
    start)
        start_tomcat
        ;;
    stop)
        stop_tomcat
        ;;
    restart)
        stop_tomcat
        sleep 3
        compile
        start_tomcat
        ;;
    *)
        echo "用法: $0 {full|compile|db|start|stop|restart}"
        echo ""
        echo "  full     - 完整部署（编译+数据库+启动）"
        echo "  compile  - 仅编译 Java 文件"
        echo "  db       - 仅初始化数据库"
        echo "  start    - 仅启动 Tomcat"
        echo "  stop     - 停止 Tomcat"
        echo "  restart  - 重新编译并重启"
        ;;
esac
