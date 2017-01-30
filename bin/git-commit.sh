clear
git status

~/dev/mildred$ bin/delpyc.sh

find $M2/CUBA/ActionsUI/modules -name "*.xml"  -exec git add -f {} \;
find $M2/CUBA/ActionsUI/modules -name "*.java"  -exec git add -f {} \;
find $M2/CUBA/ActionsUI/modules -name "*.properties"  -exec git add -f {} \;
find $M2/CUBA/ActionsUI/modules -name "*.sql"  -exec git add -f {} \;

#git add $M2/doc/*.ods
git add $M2/java/MildredCacheMonitor/*.xml
git add $M2/java/MildredCacheMonitor/*.sh
git add $M2/java/MildredCacheMonitor/*.xml
git add $M2/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/redis/*.java
git add $M2/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/*.java
git add $M2/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/swing/*.java
git add $M2/java/MildredCacheMonitor/src/main/java/com/angrysurfer/mildred/ui/javafx/*.java
git add $M2/java/MildredCacheMonitor/src/main/resources/com/angrysurfer/mildred/ui/javafx/*.fxml

git add $M2/python/test/*.py
git add $M2/python/mildred/*.py
git add $M2/python/mildred/core/*.py
git add $M2/python/mildred/db/*.py
git add $M2/python/mildred/db/generated/*.py
# git add $M2/python/mildred/db/*.sh
git add $M2/python/mildred/future/*.py
git add $M2/python/mildred/desktop/*.py
git add $M2/python/mildred/scratch/*.py

git add $M2/db/bak/*.sql
git add $M2/db/setup/*.sql
git add $M2/bin/*.sh
git add $M2/db/design/*.sql
git add $M2/db/design/*.sh
git add $M2/db/design/*.mwb
git add db/orientdb/*.json
git add db/orientdb/*.oqsl
git add db/orientdb/*.sh

git status
