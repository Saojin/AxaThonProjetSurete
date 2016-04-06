'use strict';

var config = require('./config');
var dbUtils = require('./db-utils');

dbUtils.getOrCreateDatabase(config.db.name, (err, database) => {
  if(err) {
    console.log(err);
    process.exit(1);
  }
  console.log('database "' + config.db.name + '": created');

  ['utilisateurs', 'signalements'].forEach((collectionId) => {
    dbUtils.getOrCreateCollection(database._self, collectionId, (err) => {
      if(err) {
        console.log(err);
      }
      else {
        console.log('\tcollection "' + collectionId + '": created');
      }
    });
  });
});

