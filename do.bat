@setlocal enableExtensions enableDelayedExpansion
@echo off
echo ***************************************************************
echo ** EXECUTING : %~n0

call %~dp0\stella-link.bat include

:: arguments
set "params=domain:"fasttext" action:"install build uninstall""
set "options=-f:"
call %STELLA_API%argparse %*
if "%ARGOPT_FLAG_ERROR%"=="1" goto :usage
if "%ARGOPT_FLAG_HELP%"=="1" goto :usage


set "FASTTEXT_HOME=!STELLA_APP_ROOT!\fasttext"
set "MINGW_VER=mingw-w64#mingw4_gcc4_9_2_posixthread@x86:binary"

REM --------------- FASTTEXT ----------------------------
if "%DOMAIN%"=="fasttext" (
	if "%ACTION%"=="install" (
		echo ** Install mingw-w64
		call %STELLA_API%feature_install "!MINGW_VER!"
	)

	if "%ACTION%"=="build" (
		if "%-f%"=="1" (
			call %STELLA_API%del_folder "%FASTTEXT_HOME%"
		)
		call %STELLA_API%feature_install "fasttext" "EXPORT %FASTTEXT_HOME%"

		REM retrieve mingw dll
		call %STELLA_COMMON%\common-feature.bat :feature_inspect "!MINGW_VER!"
		set "MINGW_HOME=!FEAT_INSTALL_ROOT!"
		call %STELLA_COMMON%\common.bat :copy_folder_content_into "!MINGW_HOME!\bin" "%FASTTEXT_HOME%" "*.dll"
	)
	if "%ACTION%"=="uninstall" (
		call %STELLA_API%del_folder "%STELLA_APP_WORK_ROOT%"
		call %STELLA_API%del_folder "%FASTTEXT_HOME%"
	)

)
if "%DOMAIN%"=="fasttext" goto :end


goto :eof



:usage
	echo USAGE :
	echo %~n0 %ARGOPT_HELP_SYNTAX%
	echo ----------------
	echo List of commands
	echo 	* fasttext management :
	echo 		fasttext install^|uninstall : install/uninstall build tools
	echo 		fasttext build [-f] : download and build fasttext (f option force download/rebuild)
goto :eof



:end
@echo ** END **
@cd /D %STELLA_CURRENT_RUNNING_DIR%
@echo on
@endlocal