rm *.p*
touch __init__.py
sqlacodegen mysql://root:steel@localhost/media > media.py
sqlacodegen mysql://root:steel@localhost/mildred > mildred.py
sqlacodegen mysql://root:steel@localhost/mildred_action > action.py
sqlacodegen mysql://root:steel@localhost/mildred_admin > admin.py
sqlacodegen mysql://root:steel@localhost/mildred_introspection > introspection.py
sqlacodegen mysql://root:steel@localhost/scratch > scratch.py
cat *.py