echo %PATH%
lua "%LUA_DEV%\lua\luadoc_start.lua" -d docs *.lua UI/*.lua UI/Mixins/*.lua
pause
exit