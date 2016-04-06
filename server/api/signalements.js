'use strict';

var dbUtils = require('../db-utils');

module.exports = (router, io) => {

  let document = "signalements";
  let route = router.route('/' + document);

  route.get((req, res) => {
    dbUtils.getCollection(document, (err, collection) => {
      if (err) {
        console.log(err);
      }
      var querySpec = {
        query: 'SELECT * FROM root r'
      };

      dbUtils.client.queryDocuments(collection._self, querySpec).toArray((err, results) => {
        if (err) {
          console.log(err);
        }

        res.json(results);
      });
    });
  });
  route.post((req, res) => {
    dbUtils.getCollection(document, (err, collection) => {
      if (err) {
        console.log(err);
      }

      let item = req.body;
      item.date = new Date();
      item.hasMeta = !!(item.image || item.userid);

      dbUtils.client.upsertDocument(collection._self, item, (err, document) => {
        if (err) {
          console.log(err);
        }
        
        delete document.image;
        io.sockets.emit('nouveau-signalement', document);
        res.json(document);
      });
    });
  });

  route = router.route('/' + document + '/:id');
  route.get((req, res) => {
    dbUtils.getCollection(document, (err, collection) => {
      if(err) {
        console.log(err);
      }
      var querySpec = {
        query: 'SELECT * FROM root r WHERE r.id=@id',
        parameters: [{
          name: '@id',
          value: req.params.id
        }]
      };

      dbUtils.client.queryDocuments(collection._self, querySpec).toArray((err, results) => {
        if(err) {
          console.log(err);
        }

        res.json(results[0]);
      });
    });
  });
};