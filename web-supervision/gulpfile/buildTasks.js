'use strict';

/**********************************************
 * Dépendances
 *********************************************/
var gulp = require('gulp');
var runSequence = require('run-sequence');
var gutil = require('gulp-util');
var del = require('del');
var jade = require('gulp-jade');
var fs = require('fs');
var rename = require('gulp-rename');
var KarmaServer = require('karma').Server;

var buildDir = require('../config').buildDir;

/**********************************************
 * Enregistrement des tâches
 *********************************************/
gulp.task('build:clean', cleanTask);
gulp.task('build:test', ['typescript'], testTask);
gulp.task('build:templates', ['typescript'], templatesTask);
gulp.task('build:copy-files', copyFilesTask);
gulp.task('build:rename', ['build:templates'], renameFilesTask);
gulp.task('build:bundles', ['typescript'], bundlesTask);
gulp.task('build', buildTask);


/**********************************************
 * Tâches
 *********************************************/
cleanTask.description = "Nettoie le dossier de build";
function cleanTask() {
    return del([buildDir]);
}

testTask.description = "Execute les tests";
function testTask(done) {
    var server = new KarmaServer({
        configFile: __dirname + '/../karma.conf.js',
        singleRun: true
    }, () => {});
    server.on('run_complete', (browsers, results) => {
        if(results.error) {
            let msg = results.failed > 1 ? ' tests ont échoués' : ' test a échoué'
            done(new gutil.PluginError('build:test', results.failed + msg, {showStack: false}));
            return;
        }
        done();
    });
    server.start();
}

templatesTask.description = "Transpile les templates";
function templatesTask() {
    let config = require('../config');
    require('bdlr').ENV = 'production';

    return gulp.src('./src/**/*.jade')
        .pipe(jade({
            locals: { bundles: config.bundles }
        }))
        .pipe(gulp.dest(buildDir))
}

copyFilesTask.description = "Cpoie les fichiers";
function copyFilesTask() {
    return gulp.src(['src/img/**/*']).pipe(gulp.dest(buildDir + 'src/img'));
}

renameFilesTask.description = "Renomme les fichiers";
function renameFilesTask() {
    gulp.src(buildDir + "layout.html")
      .pipe(rename(buildDir + "index.html"))
      .pipe(gulp.dest('./'));
    return del([buildDir + "layout.html"])
}

bundlesTask.description = "Créé les bundles minifiés";
function bundlesTask(done) {
    let config = require('../config');

    Object.keys(config.bundles).forEach((bundleName) => {
        var bundle = config.bundles[bundleName];
        fs.writeFileSync(buildDir + bundle.url, bundle.getMinifiedContent());
    });
    done();
}

buildTask.description = "Build l'application";
function buildTask(done) {
    runSequence(
        'build:clean', 'build:test', 'build:templates', 'build:rename', 'build:copy-files', 'build:bundles',
        (error) => {
            if(error) {
                done(new gutil.PluginError('build', error.message, {showStack: false}));
                process.exit(1);
            }
            done();
            process.exit(0);
        }
    );
}