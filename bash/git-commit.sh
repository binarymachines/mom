clear
find $MILDRED_HOME/*/python -name "*.pyc"  -exec rm {} \;
echo
git status

# ~/dev/mildred$ bash/delpyc.sh
pushd $MILDRED_HOME >> /dev/null
echo "adding files..."
echo

# find $MILDRED_HOME/CUBA -name "*.gradle"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/*/modules -name "*.xml"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/*/modules -name "*.java"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/*/modules -name "*.groovy"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/*/modules -name "*.properties"  -exec git add -f {} \;
# find $MILDRED_HOME/CUBA/*/modules -name "*.sql"  -exec git add -f {} \;

find $MILDRED_HOME -name "*.sh"  -exec git add -f {} \;

find $MILDRED_HOME/java -name "*.java"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.xml"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.groovy"  -exec git add -f {} \;
find $MILDRED_HOME/java -name "*.fxml"  -exec git add -f {} \;

# git add $MILDRED_HOME/doc/*.ods

# git add $MILDRED_HOME/java/*/*.xml
# git add $MILDRED_HOME/java/*/*.sh
# git add $MILDRED_HOME/java/*/*.xml
# git add $MILDRED_HOME/java/*/*.java
# git add $MILDRED_HOME/java/*/*.fxml

find $MILDRED_HOME/python -name "*.py"  -exec git add -f {} \;
# git add $MILDRED_HOME/python/test/*.py
# git add $MILDRED_HOME/python/mildred/*.py
# git add $MILDRED_HOME/python/mildred/core/*.py
# git add $MILDRED_HOME/python/mildred/db/*.py
# git add $MILDRED_HOME/python/mildred/db/generated/*.py
# git add $MILDRED_HOME/python/mildred/db/*.sh
# git add $MILDRED_HOME/python/mildred/future/*.py
# git add $MILDRED_HOME/python/mildred/desktop/*.py
# git add $MILDRED_HOME/python/mildred/scratch/*.py

git add $MILDRED_HOME/db/bak/*.sql
git add $MILDRED_HOME/db/setup/*.sql
# git add $MILDRED_HOME/bash/*.sh
git add $MILDRED_HOME/db/design/*.sql
git add $MILDRED_HOME/db/design/*.sh
git add $MILDRED_HOME/db/design/*.mwb

git add $MILDRED_HOME/.vscode/*.json

git add db/orientdb/*.json
git add db/orientdb/*.oqsl
git add db/orientdb/*.sh

echo
git status
echo "commiting changes: $1"
echo
git commit -m $1
echo
git status
echo "pushing commit..."
echo
git push

popd >> /dev/null
