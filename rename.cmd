@echo off
rem Renames this template to your own project.
rem   - renames the solution file to <name>.slnx
rem   - sets author and description in fxmanifest.lua
rem   - links the dist folder into the server's resources folder as <name>
rem Usage: rename.cmd            (asks for the values)
rem        rename.cmd my-resource "Author" "Description"
setlocal
cd /d "%~dp0"

rem Server resources folder the project gets linked into.
if not defined ResourcesDir set "ResourcesDir=D:\VijfM Enhanced\EAServer\txData\FiveMBasicServerCFXDefault_5F9ED8.base\resources\[scripts]"

set "ProjName=%~1"
set "Proj_author=%~2"
set "Proj_description=%~3"
if defined ProjName goto :check

:ask
set "ProjName="
set /a Tries+=1
if %Tries% gtr 5 exit /b 1
set /p "ProjName=Project name: "
if not defined ProjName goto :ask

:check
powershell -NoProfile -Command "if ($env:ProjName -notmatch '^[A-Za-z0-9][A-Za-z0-9_-]*$') { exit 1 }" <nul
if errorlevel 1 (
    echo Invalid name. Use letters, digits, - and _ only, without spaces.
    if "%~1"=="" goto :ask
    exit /b 1
)

if not "%~1"=="" goto :apply
echo Leave author or description empty to keep the current value.
set /p "Proj_author=Author: "
set /p "Proj_description=Description: "

:apply

rem Solution file
for %%f in (*.slnx *.sln) do (
    if /i not "%%~nf"=="%ProjName%" ren "%%f" "%ProjName%%%~xf"
)

rem fxmanifest.lua
powershell -NoProfile -Command "$q=[string][char]39; $m=[IO.File]::ReadAllText('fxmanifest.lua'); foreach ($k in 'author','description') { $v=[Environment]::GetEnvironmentVariable('Proj_'+$k); if ($v) { $v=$v.Replace('\','\\').Replace($q,'\'+$q); $m=[regex]::Replace($m, '(?m)^'+$k+'\s[^\r\n]*', { $k+' '+$q+$v+$q }) } }; [IO.File]::WriteAllText('fxmanifest.lua',$m)" <nul
if errorlevel 1 (
    echo Could not update fxmanifest.lua.
    exit /b 1
)

echo.
echo Done. Solution is now %ProjName%.slnx

rem Link the built resource (dist) into the server's resources folder
if not exist "%ResourcesDir%\" goto :nolink
if exist "%ResourcesDir%\%ProjName%" goto :linkexists
if not exist dist mkdir dist
mklink /J "%ResourcesDir%\%ProjName%" "%~dp0dist" >nul
if errorlevel 1 goto :linkfailed
echo Linked "%ResourcesDir%\%ProjName%" to "%~dp0dist"
echo Run build.cmd, then add "ensure %ProjName%" to server.cfg.
goto :end

:nolink
echo Server resources folder not found, no link created:
echo   %ResourcesDir%
echo Name the resource folder on your server "%ProjName%".
goto :end

:linkexists
echo "%ResourcesDir%\%ProjName%" already exists, no link created.
goto :end

:linkfailed
echo Could not create the link in "%ResourcesDir%".

:end
if "%~1"=="" pause
