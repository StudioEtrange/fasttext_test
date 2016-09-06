#!/bin/bash
_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"
source $_CURRENT_FILE_DIR/stella-link.sh include


function usage() {
	echo "USAGE :"
	echo "----------------"
	echo "o-- fasttext management :"
	echo "L     fasttext build [-f]"
	echo "L     fasttext uninstall"

}

# COMMAND LINE -----------------------------------------------------------------------------------
PARAMETERS="
DOMAIN=											'domain' 			a				'fasttext'
ID=												'' 					a				'build uninstall'
"
OPTIONS="
FORCE=''				   'f'		  ''					b			0		'1'					  Force.
"
$STELLA_API argparse "$0" "$OPTIONS" "$PARAMETERS" "fasttext-test" "$(usage)" "APPARG" "$@"

#-------------------------------------------------------------------------------------------

FASTTEXT_HOME="$STELLA_APP_ROOT/fasttext"

# ------------- ENV ----------------------------
if [ "$DOMAIN" == "fasttext" ]; then
	if [ "$ID" == "build" ]; then
		if [ "$FORCE" == "1" ]; then
			$STELLA_API del_folder "$FASTTEXT_HOME"
		fi
		$STELLA_API feature_install "fasttext" "EXPORT $FASTTEXT_HOME"
	fi

	if [ "$ID" == "uninstall" ]; then
		$STELLA_API del_folder "$FASTTEXT_HOME"
	fi

fi
