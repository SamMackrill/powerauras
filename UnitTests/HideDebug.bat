cd utils
sed.exe -i -c "s/self:UnitTestInfo(/--self:UnitTestInfo(/g" ..\..\*.lua
sed.exe -i -c "s/PowaAuras:UnitTestInfo(/--PowaAuras:UnitTestInfo(/g" ..\..\*.lua
sed.exe -i -c "s/function --PowaAuras:UnitTestInfo(/function PowaAuras:UnitTestInfo(/g" ..\..\*.lua
@pause
@exit