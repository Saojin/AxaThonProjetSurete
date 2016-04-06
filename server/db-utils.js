var DocumentClient = require('documentdb').DocumentClient;

var conf = require('./config');

module.exports = {
  client: new DocumentClient(conf.db.host, {masterKey: conf.db.masterKey}),
  getOrCreateDatabase: function (databaseId, callback) {
    var querySpec = {
      query: 'SELECT * FROM root r WHERE r.id=@id',
      parameters: [{
        name: '@id',
        value: databaseId
      }]
    };

    this.client.queryDatabases(querySpec).toArray((err, results) => {
      if (err) {
        callback(err);

      } else {
        if (results.length === 0) {
          var databaseSpec = {
            id: databaseId
          };

          this.client.createDatabase(databaseSpec, (err, created) => {
            callback(null, created);
          });

        } else {
          callback(null, results[0]);
        }
      }
    });
  },

  getOrCreateCollection: function (databaseLink, collectionId, callback) {
    var querySpec = {
      query: 'SELECT * FROM root r WHERE r.id=@id',
      parameters: [{
        name: '@id',
        value: collectionId
      }]
    };

    this.client.queryCollections(databaseLink, querySpec).toArray((err, results) => {
      if (err) {
        callback(err);

      } else {
        if (results.length === 0) {
          var collectionSpec = {
            id: collectionId
          };

          var requestOptions = {
            offerType: 'S1'
          };

          this.client.createCollection(databaseLink, collectionSpec, requestOptions, (err, created) => {
            callback(null, created);
          });

        } else {
          callback(null, results[0]);
        }
      }
    });
  },

  getDatabase: function (callback) {
    this.getOrCreateDatabase(conf.db.name, callback);
  },

  getCollection: function (collectionId, callback) {
    this.getDatabase((_, database) => {
      this.getOrCreateCollection(database._self, collectionId, callback);
    });
  }
};