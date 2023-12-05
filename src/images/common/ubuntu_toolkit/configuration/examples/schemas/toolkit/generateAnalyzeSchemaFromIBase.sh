#!/bin/bash

#
# i2, i2 Group, the i2 Group logo, and i2group.com are trademarks of N.Harris Computer Corporation.
# © N.Harris Computer Corporation (2022)
#

pushdQuiet () {
    command pushd $1 > /dev/null
}

popdQuiet () {
    command popd > /dev/null
}

SDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
pushdQuiet $SDIR

if [[ -z JAVA_HOME ]]; then
  echo "Error: JAVA_HOME environment variable not set.

Set the JAVA_HOME variable in your environment to match the
location of your Java installation."
  popdQuiet
  exit 1
elif [ -f "$JAVA_HOME/bin/java" ]; then
  echo "Using the JAVA_HOME environment variable."
  $JAVA_HOME/bin/java -Dlog4j.configurationFile=ibase_schema_gen_log4j2.xml -cp ./classes:./lib/* com.i2group.disco.daod.ibase.AnalyzeSchemaFromIBaseCLI "$@"
else
  echo "Error: Java not found in the $JAVA_HOME directory.

Set the JAVA_HOME variable in your environment to match the
location of your Java installation."
  popdQuiet
  exit 1
fi

popdQuiet
