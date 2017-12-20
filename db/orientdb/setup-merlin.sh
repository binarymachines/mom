pushd $ORIENTDB_HOME/bin

./console.sh $MILDRED_HOME/db/orientdb/merlin-drop.oqsl
./console.sh $MILDRED_HOME/db/orientdb/merlin-create.oqsl

./oetl.sh $MILDRED_HOME/db/orientdb/etl-import-dispatch.json
./oetl.sh $MILDRED_HOME/db/orientdb/etl-import-reason.json
./oetl.sh $MILDRED_HOME/db/orientdb/etl-import-reason-param.json
./oetl.sh $MILDRED_HOME/db/orientdb/etl-import-action.json
./oetl.sh $MILDRED_HOME/db/orientdb/etl-import-action-reason.json

popd