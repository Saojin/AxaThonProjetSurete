'use strict';

/**********************************************
 * Dépendances
 *********************************************/
var gulp = require('gulp');
var spawn = require('child_process').spawn;
var tsconfig = require("gulp-tsconfig-files");
var changed = require('gulp-changed');
var ts = require('gulp-typescript');
var ngAnnotate = require('gulp-ng-annotate');
var sourcemaps = require('gulp-sourcemaps');
var livereload = require('gulp-livereload');
var KarmaServer = require('karma').Server;


/**********************************************
 * Enregistrement des tâches
 *********************************************/
gulp.task('server', serverTask);
gulp.task('reloadJade', reloadJadeTask);
gulp.task('tdd');
gulp.task('tsconfigGlob', tsconfigGlobTask);
gulp.task('typescript', ['tsconfigGlob'], typescriptTask);
gulp.task('default', ['typescript', 'server'], () => {
    livereload.listen({quiet: true});

    // Start unit tests
    new KarmaServer({
        configFile: __dirname + '/../karma.conf.js',
        singleRun: false,
        autoWatch: true
    }).start();

    gulp.watch(['./index.js', './config.js'], ['server']);
    gulp.watch(['src/**/*.ts', 'test/**/*.ts'], ['typescript']);
    gulp.watch(['src/**/*.jade'], ['reloadJade'])
});

/**********************************************
 * Tâches
 *********************************************/
var node = null;
serverTask.description = 'Démarre le serveur node local pour développer';
function serverTask() {
    if (node) {
        console.log('Restarting the server...');
        node.kill();
    }
    node = spawn('node', ['server.js'], {stdio: 'inherit'});
    node.on('close', function (code) {
        if (code === 8) {
            gulp.log('Error detected, waiting for changes...');
        }
    });
}
// On éteint les lumières et ferme la porte..
process.on('exit', () => {
    if(node) {
        console.log('Stoping the server...');
        node.kill();
    }
});

reloadJadeTask.description = "Recharge la page si un template jade a changé";
function reloadJadeTask(done) {
    gulp.src('src/**/*.jade', {read: false})
        .pipe(changed('.', {extension: '.jade'}))
        .pipe(livereload());
    done();
}

tsconfigGlobTask.description = "Génère la partie file du fichier tsconfig";
function tsconfigGlobTask() {
    let tsProject = ts.createProject('tsconfig.json');
    return gulp.src(tsProject.config.filesGlob)
        .pipe(tsconfig());
}

typescriptTask.description = "Transpile les fichiers typescripts";
function typescriptTask() {
    var tsProject = ts.createProject('tsconfig.json');
    return tsProject.src()
        .pipe(sourcemaps.init())
        .pipe(changed('.', {extension: '.js'}))
        .pipe(ts(tsProject)).js
        .pipe(ngAnnotate())
        .pipe(sourcemaps.write({sourceRoot: ''}))
        .pipe(gulp.dest('./'))
        .pipe(livereload());
}