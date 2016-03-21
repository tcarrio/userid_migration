:: Author: Tom Carrio
:: Purpose: CLI Application designed to help export and import a user.id file across a 
:: USB device medium. Copy to a USB and run on a computer to extract/import the user.id
:: file of a users IBM Notes. 

@echo off
:Introduction
set _SCRIPT_DIR=%~dp0
echo "%_SCRIPT_DIR%"
echo User ID Migration Utility
echo ===========================
echo 1: Extract
echo 2: Import
echo 3: Exit
set /P toolchoice=Enter which tool you would like to use: 
if "%toolchoice%"=="1" GOTO :ExtractionTool
if "%toolchoice%"=="2" GOTO :ImportTool
if "%toolchoice%"=="3" GOTO :End
GOTO :Introduction

::
:: Extraction Tool for Migration Utility
::
:ExtractionTool
echo Notes ID Extraction Utility
echo ===========================
:: DISPLAY USERNAME
if [%USERNAME%]==[] GOTO :UsernameError
echo Current user is %USERNAME%
set /P usercorrect=Is this correct? (Y/N) 
if not "%USERDOMAIN%"=="MYDOMAIN" GOTO :DomainMismatch
:: CHECK FOR C:\User\<userid>\appdata\local\IBM\notes\data
:: EXTRACT TO USB
xcopy C:\Users\%USERNAME%\appdata\local\IBM\notes\data\user.id %_SCRIPT_DIR%\data\%USERNAME%\
GOTO :SuccessMsg

::
:: IMPORT TOOL FOR MIGRATION UTILITY
::
:ImportTool
echo Notes ID Extraction Utility
echo ===========================
if [%USERNAME%]==[] GOTO :UsernameError
echo Current user is %USERNAME%
set /P usercorrect=Is this correct? (Y/N) 
if "%usercorrect%"=="N" GOTO :End
if not "%USERDOMAIN%"=="MYDOMAIN" GOTO :DomainMismatch
if not exist %_SCRIPT_DIR%\data\%USERNAME%\user.id GOTO :NoIdFile
echo "%_SCRIPT_DIR%\data\%USERNAME%\user.id"
echo C:\Users\%USERNAME%\appdata\local\IBM\notes\data\
xcopy %_SCRIPT_DIR%\data\%USERNAME%\user.id C:\Users\%USERNAME%\appdata\local\IBM\notes\data\
GOTO :SuccessMsg

:: ERROR HANDLING

:UsernameError
echo Username not set in system variables
GOTO :End

:DomainMismatch
echo Domain not matched
GOTO :End

:NoIdFile
echo User.id file not found
GOTO :End

:DataFolderError
echo Data migration folder not found
GOTO :End

:SuccessMsg
echo Successfully completed migration
pause

:End
