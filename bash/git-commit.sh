pushd $MILDRED_HOME >> /dev/null
clear
find $MILDRED_HOME -name "*.pyc"  -exec rm {} \;
echo
git status

# ~/dev/mildred$ bash/delpyc.sh
echo "adding files..."
echo

find $MILDRED_HOME -name "*.sh"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.properties"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.java"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.xml"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.groovy"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.fxml"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.gradle"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.txt"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.py"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.oqsl"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.mwb"  -exec git add -f {} \;
find $MILDRED_HOME -name "*.ods"  -exec git add -f {} \;

git add $MILDRED_HOME/db/bak/*.sql
git add $MILDRED_HOME/db/design/*.sql
git add $MILDRED_HOME/db/setup/*.sql
git add $MILDRED_HOME/db/design/*.mwb
git add $MILDRED_HOME/.vscode/*.json
git add $MILDRED_HOME/db/orientdb/*.json

echo
git status
echo
if [ "$#" -ne 1 ];
then
    echo "commiting snapshot"
    git commit -m snapshot
else    
    echo "commiting changes: $1"
    git commit -m $1
fi

echo
git status
echo "pushing commit..."
echo
git push

popd >> /dev/null
