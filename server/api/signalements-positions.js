'use strict';
var dbUtils = require('../db-utils');

module.exports = (router) => {
  let document = 'signalements-positions';

  let route = router.route('/' + document);
  route.get((req, res) => {
    dbUtils.getCollection('signalements', (err, collection) => {
      if (err) {
        console.log(err);
      }
      var querySpec = {
        query: "SELECT r.id,r.position,r.date,r.hasMeta FROM root r"
      };

      dbUtils.client.queryDocuments(collection._self, querySpec).toArray((err, results) => {
        if (err) {
          console.log(err);
        }

        res.json(results);
      });
    });
  });
};