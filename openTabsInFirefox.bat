rem delayed expansion for not getting cummulative string
rem built for access error list in for loop
rem
setlocal EnableDelayedExpansion
echo off
rem batch file to open webtabs for each error in a file

set src="C:\Users\jfernandez037\Documents\BSabadell\ErrorLogs"
set prog="c:\Program Files (x86)\Mozilla Firefox\firefox.exe"
rem URL for error detail in each tab
rem set ldapUrlA="https://3.249.85.76/cgi/loginerrors.cgi?base=3.249.85.76&advanced_search=off&search_value=3.249.85.76&search_token="
rem set ldapUrlB="&search_choice=username&port=443&host=3.249.85.76&auth_username=jordifernandez.ext@bsextranet.bancsabadell.com&auth_password=poTGS.@D390&param0=ntUserDomainId&custom_display=ntUserDomainId&scope=sub"
rem set name=jordifernandez.ext@bsextranet.bancsabadell.com
rem set password=poTGS.@D390
rem URL for error display
for /F %%x in (%src%) do (
	
	set qURL="https://3.249.85.76/cgi/loginerrors.cgi?base=3.249.85.76&advanced_search=off&search_value=3.249.85.76&search_token="%%x"&search_choice=username&port=443&host=3.249.85.76&auth_username=jordifernandez.ext@bsextranet.bancsabadell.com&auth_password=poTGS.@D390&param0=ntUserDomainId&custom_display=ntUserDomainId&scope=sub"
	start "title" %prog% !qUrl!
	timeout 2
	rem start "title" %prog% %errorUrl%%%i
	rem set tmpSumErrorUrl=!sumErrorUrl!%%i" "
	rem set sumErrorUrl=!tmpSumErrorUrl!
)
rem pause
rem for /F %%i in (%src%) do start "title" %ieProg% %errorUrl%%%i