cd utils
sed.exe -i -c "s/--self:UnitTestInfo(/self:UnitTestInfo(/g" ..\..\*.lua
sed.exe -i -c "s/--PowaAuras:UnitTestInfo(/PowaAuras:UnitTestInfo(/g" ..\..\*.lua
sed.exe -i -c "s/--self:UnitTestDebug(/self:UnitTestDebug(/g" ..\..\*.lua
sed.exe -i -c "s/--PowaAuras:UnitTestDebug(/PowaAuras:UnitTestDebug(/g" ..\..\*.lua
@pause
@exit