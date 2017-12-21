clear
git status

# ~/dev/mildred$ bash/delpyc.sh
pushd $MILDRED_HOME

find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.pyc"  -exec rm {} \;

# find $MILDRED_HOME/CUBA -name "*.gradle"  -exec git add -f {} \;

# find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.xml"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.java"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.groovy"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.properties"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/ActionsUI/modules -name "*.sql"  -exec git add -f {} \;

# find $MILDRED_HOME/CUBA/PrimaryUI/modules -name "*.xml"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/PrimaryUI/modules -name "*.java"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/PrimaryUI/modules -name "*.groovy"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/PrimaryUI/modules -name "*.properties"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/PrimaryUI/modules -name "*.sql"  -exec git add -f {} \;

find $MILDRED_HOME/java -name "*.java"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.sh"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.xml"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.groovy"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.fxml"  -exec git add -f {} \;
# find $MILDRED_HOME/java -name "*.xml"  -exec git add -f {} \;
# find $MILDRED_HOME/java -name "*.xml"  -exec git add -f {} \;

#git add $MILDRED_HOME/doc/*.ods
# git add $MILDRED_HOME/java/MildredCacheMonitor/*.xml
# git add $MILDRED_HOME/java/MildredCacheMonitor/*.sh
# git add $MILDRED_HOME/java/MildredCacheMonitor/*.xml
# git add $MILDRED_HOME/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/redis/*.java
# git add $MILDRED_HOME/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/*.java
# git add $MILDRED_HOME/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/swing/*.java
# git add $MILDRED_HOME/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/javafx/*.java
# git add $MILDRED_HOME/java/MildredCacheMonitor/src/main/resources/com/angrysurfer/mildred/ui/javafx/*.fxml

# find $MILDRED_HOME/python -name "*.py"  -exec git add -f {} \;
git add $MILDRED_HOME/python/test/*.py
git add $MILDRED_HOME/python/mildred/*.py
git add $MILDRED_HOME/python/mildred/core/*.py
git add $MILDRED_HOME/python/mildred/db/*.py
git add $MILDRED_HOME/python/mildred/db/generated/*.py
# git add $MILDRED_HOME/python/mildred/db/*.sh
git add $MILDRED_HOME/python/mildred/future/*.py
git add $MILDRED_HOME/python/mildred/desktop/*.py
git add $MILDRED_HOME/python/mildred/scratch/*.py

git add $MILDRED_HOME/db/bak/*.sql
git add $MILDRED_HOME/db/setup/*.sql
git add $MILDRED_HOME/bash/*.sh
git add $MILDRED_HOME/db/design/*.sql
git add $MILDRED_HOME/db/design/*.sh
git add $MILDRED_HOME/db/design/*.mwb
git add db/orientdb/*.json
git add db/orientdb/*.oqsl
git add db/orientdb/*.sh

git status
git commit -m $1
git status
git push

popd