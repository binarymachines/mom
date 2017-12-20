sudo pip install wheel

hg clone https://bitbucket.org/pygame/pygame
cd pygame
sudo pip wheel .

cd
git clone git@github.com:kivy/kivy.git
git checkout 1.8.0
cd kivy
make force
sudo pip wheel .

mkvirtualenv kivy-env
sudo pip install kivy
sudo pip install pygame --pre