#!/bin/bash

usage() { echo "Usage: $0 -m <path to moses installation>
		          -h <path to mosesmodels home> 
			  -e <model or engine name> 
			  -s <machine translation source language - en or cy>
			  -t <machine translation target language - en or cy>" 1>&2; exit 1; }

while getopts ":m:h:e:s:t:" o; do
	case "${o}" in
		m)	MOSES_HOME=${OPTARG}
			;;
		h) 
			MOSESMODELS_HOME=${OPTARG}
			;;
		e)
			NAME=${OPTARG}		
			;;
		s)
			SOURCE_LANG=${OPTARG}		
			;;		
		t)
			TARGET_LANG=${OPTARG}		
			;;
		*)
			usage	
			;;
	esac
done  
shift $((OPTIND-1))

if [ -z "${MOSES_HOME}" ] || [ -z "${MOSESMODELS_HOME}" ] || [ -z "${NAME}" ] || [ -z "${SOURCE_LANG}" ] || [ -z "${TARGET_LANG}" ]; then
    usage
fi

cd ${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}

echo "##### PHRASE TABLE #####"
gunzip engine/model/phrase-table.gz
cat engine/model/phrase-table | LC_ALL=C sort | ${MOSES_HOME}/mosesdecoder/bin/processPhraseTable -ttable 0 0 - -nscores 5 -out engine/model/phrase-table

echo "##### REORDERING TABLE #####"
gunzip engine/model/reordering-table.wbe-msd-bidirectional-fe.gz
cat engine/model/reordering-table.wbe-msd-bidirectional-fe | LC_ALL=C sort | ${MOSES_HOME}/mosesdecoder/bin/processLexicalTable -out engine/model/reordering-table.wbe-msd-bidirectional-fe

echo "##### YOU MUST NOW EDIT MOSES.INI AT : "
echo "${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/engine/model/moses.ini"
echo "#####"
echo ""
echo "[ttable-file]"
echo "#0 0 0 5 ${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/engine/model/phrase-table.gz"
echo "1 0 0 5 ${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/engine/model/phrase-table"
echo ""
echo "[distortion-file]"
echo "#0-0 wbe-msd-bidirectional-fe-allff 6 ${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/engine/model/reordering-table.wbe-msd-bidirectional-fe.gz"
echo "0-0 wbe-msd-bidirectional-fe-allff 6 ${MOSESMODELS_HOME}/${NAME}/${SOURCE_LANG}-${TARGET_LANG}/engine/model/reordering-table.wbe-msd-bidirectional-fe"

cd -

