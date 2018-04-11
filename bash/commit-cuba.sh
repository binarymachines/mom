clear

git status

git add commit.sh
git add $1/*.sh
#git add $1/*.gradle

git add $1/modules/*/src/*/*.xml 
git add $1/modules/core/web/web/*/*.xml 
git add $1/modules/core/web/*/*.xml 
git add $1/modules/*/src/*/*.java
git add $1/modules/*/src/*/*.groovy
git add $1/modules/*/src/*/*.properties

git status

#git commit -m "snapshot"
#git push
#git status
git diff HEAD $1/build.gradle
git diff HEAD $1/modules/core/web/META-INF/context.xml
