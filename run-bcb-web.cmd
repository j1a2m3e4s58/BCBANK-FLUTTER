@echo off
cd /d "%~dp0"
"C:\flutter\flutter\bin\flutter.bat" run --no-pub -d web-server --web-hostname 127.0.0.1 --web-port 4180 > flutter-web.out.log 2> flutter-web.err.log
