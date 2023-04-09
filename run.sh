#!/bin/bash

# Note that main.log is stored in ~/.pywikibot/logs/

# Activate virtualenv
. ENV/bin/activate

# Update pywikibot
echo "📦 Updating pywikibot"
cd pywikibot && git pull && cd ..

echo "🏡 Working dir: $(pwd)"

# Set Pywikibot path
# PYWIKI=/shared/pywikipedia/core
PYWIKI=$(pwd)/pywikibot
export PYTHONPATH=$PYWIKI/scripts:$PYTHONPATH

LOG=public_html/out
STATUS=public_html/status
rm $LOG
touch $LOG

echo "------------------------------------------"
python $PYWIKI/pwb.py version
echo "------------------------------------------"

echo 'true' > $STATUS
echo ----------------------------------------------------------- >> $LOG
echo `date` : Bot started >> $LOG
echo ----------------------------------------------------------- >> $LOG
stdbuf -o 0 python $PYWIKI/scripts/archivebot.py -lang:no -log:main.log Autoarkivering 2>&1 | tee -a $LOG
stdbuf -o 0 python $PYWIKI/scripts/archivebot.py -lang:se -log:main.log "ArkivBot/config" 2>&1 | tee -a $LOG
echo ----------------------------------------------------------- >> $LOG
echo `date` : Bot finished >> $LOG
echo ----------------------------------------------------------- >> $LOG

echo 'false' > $STATUS
