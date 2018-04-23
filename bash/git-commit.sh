pushd $MILDRED_HOME >> /dev/null
clear
echo
git status

find $MILDRED_HOME -name "*.pyc"  -exec rm {} \;

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

# git add $MILDRED_HOME/cuba/*.sh
git add $MILDRED_HOME/cuba/modules/*/src/*/*.xml 
git add $MILDRED_HOME/cuba/modules/*/src/*/*.java
git add $MILDRED_HOME/cuba/modules/*/src/*/*.groovy
git add $MILDRED_HOME/cuba/modules/*/src/*/*.properties

# git add $MILDRED_HOME/cuba/modules/*/test/*/*.xml 
# git add $MILDRED_HOME/cuba/modules/*/test/*/*.java
# git add $MILDRED_HOME/cuba/modules/*/test/*/*.groovy
# git add $MILDRED_HOME/cuba/modules/*/test/*/*.properties

# git add $MILDRED_HOME/cuba/modules/*/web/*/*.xml 
# git add $MILDRED_HOME/cuba/modules/*/web/*/*.java
# git add $MILDRED_HOME/cuba/modules/*/web/*/*.groovy
# git add $MILDRED_HOME/cuba/modules/*/web/*/*.properties

git add $MILDRED_HOME/cuba/modules/*/themes/*/*.scss 
git add $MILDRED_HOME/cuba/modules/*/themes/*/*.png
git add $MILDRED_HOME/cuba/modules/*/themes/*/*.ico
git add $MILDRED_HOME/cuba/modules/*/themes/*/*.properties

# echo
# if [ "$#" -ne 1 ];
# then
#     echo "commiting snapshot"
#     git commit -m snapshot
# else    
#     echo "commiting changes: $1"
#     git commit -m $1
# fi

# echo
# git status

# echo "pushing commit..."
# echo
# git push
git status
#git diff HEAD $1/build.gradle
#git diff HEAD $1/modules/core/web/META-INF/context.xml

popd >> /dev/null
