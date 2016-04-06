'use strict';

/**********************************************
 * Dépendances
 *********************************************/
var gulp = require('gulp');
var tsd = require('gulp-tsd');
var bower = require('gulp-bower');


/**********************************************
 * Enregistrement des tâches
 *********************************************/
gulp.task('install:tsd', tsdTask);
gulp.task('install:bower', bowerTask);
gulp.task('install', ['install:tsd', 'install:bower']);


/**********************************************
 * Tâches
 *********************************************/
tsdTask.description = 'Installe les fichiers tsd';
function tsdTask(done) {
    tsd({
        command: 'reinstall',
        config: './tsd.json'
    }, done);
}

bowerTask.description = 'Installe les dépendances bower';
function bowerTask() {
    return bower();
}
