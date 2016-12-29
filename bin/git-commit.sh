clear
git status

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
[ ! -f "*.pyc" ] && rm $M2/python/test/*.pyc
git add $M2/python/mildred/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/*.pyc
git add $M2/python/mildred/core/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/core/*.pyc
git add $M2/python/mildred/db/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/db/*.pyc
git add $M2/python/mildred/db/generated/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/db/generated/*.pyc
# git add $M2/python/mildred/db/*.sh
git add $M2/python/mildred/future/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/future/*.pyc
git add $M2/python/mildred/desktop/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/desktop/*.pyc
git add $M2/python/mildred/scratch/*.py
[ ! -f "*.pyc" ] && rm $M2/python/mildred/scratch/*.pyc

git add $M2/db/bak/*.sql
git add $M2/db/setup/*.sql
git add $M2/bin/*.sh
git add $M2/db/design/*.sql
git add $M2/db/design/*.mwb
git add db/orientdb/*.json

git status
