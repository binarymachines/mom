pushd $ORIENTDB_HOME/bin

# ./console.sh $M2/db/orientdb/merlin-truncate.oqsl
# ./console.sh $M2/db/orientdb/merlin-create.oqsl

# ./oetl.sh $M2/db/orientdb/etl-import-dispatch.json
# ./oetl.sh $M2/db/orientdb/etl-import-reason.json
# ./oetl.sh $M2/db/orientdb/etl-import-action.json
./oetl.sh $M2/db/orientdb/etl-import-action-reason.json

popd