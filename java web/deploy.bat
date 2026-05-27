@echo off
chcp 65001 >nul 2>&1
title 用户综合管理系统 - 一键部署

set JAVA_HOME=C:\Program Files\Java\jdk-17
set CATALINA_HOME=D:\tomcat\apache-tomcat-10.1.53
set CATALINA_BASE=%~dp0tomcat-base
set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
set MYSQL_USER=root
set MYSQL_PASS=2234178482
set PROJECT_DIR=%~dp0
set SRC_DIR=%PROJECT_DIR%src
set WEB_DIR=%PROJECT_DIR%web
set OUT_DIR=%WEB_DIR%\WEB-INF\classes
set LIB_DIR=%WEB_DIR%\WEB-INF\lib
set MYSQL_JAR=%LIB_DIR%\mysql-connector-java-8.0.28.jar
set TOMCAT_SERVLET=%CATALINA_HOME%\lib\servlet-api.jar
set TOMCAT_JSP=%CATALINA_HOME%\lib\jsp-api.jar

echo ============================================
echo    用户综合管理系统 - 一键部署脚本
echo ============================================
echo.

:menu
echo 请选择操作：
echo   [1] 完整部署（编译+数据库+启动）
echo   [2] 仅编译 Java 文件
echo   [3] 仅初始化数据库
echo   [4] 仅启动 Tomcat
echo   [5] 停止 Tomcat
echo   [6] 重新编译并重启
echo   [0] 退出
echo.
set /p choice=请输入选项：

if "%choice%"=="1" goto full_deploy
if "%choice%"=="2" goto compile
if "%choice%"=="3" goto init_db
if "%choice%"=="4" goto start_tomcat
if "%choice%"=="5" goto stop_tomcat
if "%choice%"=="6" goto recompile_restart
if "%choice%"=="0" goto end
echo 无效选项，请重新选择
echo.
goto menu

:full_deploy
echo.
echo [步骤1/3] 编译 Java 文件...
call :compile
if %errorlevel% neq 0 goto error

echo.
echo [步骤2/3] 初始化数据库...
call :init_db
if %errorlevel% neq 0 goto error

echo.
echo [步骤3/3] 启动 Tomcat...
call :start_tomcat
goto end

:compile
echo 正在清理旧的 class 文件...
if exist "%OUT_DIR%" (
    rd /s /q "%OUT_DIR%"
)
mkdir "%OUT_DIR%"

echo 正在编译 Java 源文件...
"%JAVA_HOME%\bin\javac" -encoding UTF-8 -cp "%MYSQL_JAR%;%TOMCAT_SERVLET%;%TOMCAT_JSP%;%OUT_DIR%" -d "%OUT_DIR%" "%SRC_DIR%\dbutil\*.java" "%SRC_DIR%\entity\*.java" "%SRC_DIR%\util\*.java" "%SRC_DIR%\model\*.java" "%SRC_DIR%\servlet\*.java" "%SRC_DIR%\filter\*.java"

if %errorlevel% equ 0 (
    echo [成功] 编译完成！
    dir /s /b "%OUT_DIR%\*.class" | find /c ".class" >nul
    echo class 文件已输出到 %OUT_DIR%
) else (
    echo [失败] 编译出错，请检查源代码！
)
goto :eof

:init_db
echo 正在初始化数据库...
"%MYSQL_PATH%" -u %MYSQL_USER% -p%MYSQL_PASS% -e "SOURCE %PROJECT_DIR%user.sql" 2>nul
if %errorlevel% equ 0 (
    echo [成功] 数据库初始化完成！
) else (
    echo [失败] 数据库初始化出错，请检查 MySQL 是否运行！
)
goto :eof

:start_tomcat
echo 正在启动 Tomcat...
if not exist "%CATALINA_BASE%\conf\Catalina\localhost" (
    mkdir "%CATALINA_BASE%\conf\Catalina\localhost"
)
if not exist "%CATALINA_BASE%\logs" mkdir "%CATALINA_BASE%\logs"
if not exist "%CATALINA_BASE%\temp" mkdir "%CATALINA_BASE%\temp"
if not exist "%CATALINA_BASE%\work" mkdir "%CATALINA_BASE%\work"

echo.
echo ============================================
echo   Tomcat 已启动！
echo   访问地址: http://localhost:8080/UserManage/
echo   登录账号: admin / admin123
echo ============================================
echo.
start "Tomcat - UserManage" "%CATALINA_HOME%\bin\catalina.bat" run
goto end

:stop_tomcat
echo 正在停止 Tomcat...
call "%CATALINA_HOME%\bin\catalina.bat" stop
echo [完成] Tomcat 已停止
goto end

:recompile_restart
echo 正在停止 Tomcat...
call "%CATALINA_HOME%\bin\catalina.bat" stop
timeout /t 3 /nobreak >nul

echo.
echo 正在重新编译...
call :compile

echo.
echo 正在启动 Tomcat...
call :start_tomcat
goto end

:error
echo.
echo [错误] 部署过程中出现错误，请检查上方日志！
pause
goto end

:end
echo.
pause
