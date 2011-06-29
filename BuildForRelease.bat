cd ..
"C:\Program Files\7-Zip\7z.exe" a -tzip -xr!PowerAuras\UnitTests\* -xr!PowerAuras\UnitTests -xr!?hg\* -x!PowerAuras\.hg* -x!PowerAuras\*.bat -x!PowerAuras\*.session -x!PowerAuras\docs\* PowerAuras.zip PowerAuras\
@pause
@exit
