'use strict';

var dbUtils = require('./db-utils');

dbUtils.getCollection('signalements', (err, collection) => {
  if (err) {
    console.log(err);
  }


  [{
    position: { latitude: 48.856614, longitude: 2.3872219000000177 }
  },{
    position: { latitude: 48.845614, longitude: 2.35221519000000177 }
  },{
    position: { latitude: 48.845614, longitude: 2.35221519000000177 }
  },{
    position: { latitude: 48.945614, longitude: 2.35221589000000177 }
  },{
    position: { latitude: 48.845664, longitude: 2.35226519000000177 }
  },{
    position: { latitude: 48.845619, longitude: 2.35221519000600177 }
  }].forEach((item) => {
    item.date = new Date();

    dbUtils.client.upsertDocument(collection._self, item, (err, document) => {
      if (err) {
        console.log(err);
      }
    });
  });
});
