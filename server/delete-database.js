'use strict';

var config = require('./config');
var dbUtils = require('./db-utils');

dbUtils.getOrCreateDatabase(config.db.name, (err, database) => {
  if(err) {
    console.log(err);
    process.exit(1);
  }
  dbUtils.client.deleteDatabase(database._self, (err) => {
    if(err) {
      console.log(err);
      process.exit(1);
    }
    console.log('database "' + config.db.name + '": deleted');
  });
});