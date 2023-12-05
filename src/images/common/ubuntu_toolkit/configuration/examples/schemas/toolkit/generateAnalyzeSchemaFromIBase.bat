@echo off

SET SDIR=%~dp0
pushd %SDIR%

if NOT DEFINED JAVA_HOME (
  echo Error: JAVA_HOME environment variable not set.
  echo.
  echo Set the JAVA_HOME variable in your environment to match the location of your Java installation.
  goto finish
)

if exist "%JAVA_HOME%\bin\java*" (
  echo Using the JAVA_HOME environment variable.
  "%JAVA_HOME%\bin\java" -Dlog4j.configurationFile=ibase_schema_gen_log4j2.xml -cp .\classes;.\lib\* com.i2group.disco.daod.ibase.AnalyzeSchemaFromIBaseCLI %*
  goto finish
)

echo Error: Java not found in the %JAVA_HOME% directory.
echo.
echo Set the JAVA_HOME variable in your environment to match the location of your Java installation.
:finish
popd

:NORMALIZEPATH
  SET RETVAL=%~f1
