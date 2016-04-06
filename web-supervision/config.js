var bdlr = require('bdlr');

bdlr.createBundle('style', bdlr.STYLE, 'style.bundle.css').includeGlob('bower_components/*/*.css');
bdlr.createBundle('lib', bdlr.SCRIPT, 'lib.bundle.js')
  .includeFile('bower_components/lodash/dist/lodash.min.js')
  .includeFile('bower_components/angular/angular.js')
  .includeFile('bower_components/angular-google-maps/dist/angular-google-maps.js')
  .includeFile('bower_components/angular-simple-logger/dist/angular-simple-logger.min.js')
  .includeGlob('bower_components/*/*.js', ['bower_components/*/index.js','bower_components/angular-simple-logger/*.js', 'bower_components/*/*-mocks.js', 'bower_components/angular-mocks/*.js']);
bdlr.createBundle('app', bdlr.SCRIPT, 'app.bundle.js').includeGlob('src/**/*.js').includeFile('src/app.js');

module.exports = {
   buildDir: './dist/',
   app: {
      port: 9000
   },
   liveReload: {
      port: 35729
   },
   bundles: bdlr.bundles
};