/// <reference path="../typings/tsd.d.ts" />

'use strict';

(() => {
    var app:ng.IModule = angular.module('emergen6', ['ngMaterial','ngRoute','uiGmapgoogle-maps','ngResource']);
    app.config(appConfig);
    
    function appConfig($mdThemingProvider:ng.material.IThemingProvider, $routeProvider:ng.route.IRouteProvider,uiGmapGoogleMapApiProvider:any) { 
        'ngInject';
        
        $mdThemingProvider.theme('default')
            .primaryPalette('pink')
            .accentPalette('orange');
            
            $routeProvider.when('/', {
                templateUrl: 'views/regie.html',
                controller: 'RegieCtrl',
                controllerAs: 'ctrl'
            }).otherwise({ redirectTo: '/' });
            
            uiGmapGoogleMapApiProvider.configure({
                key: 'AIzaSyA_JkeKrjvKkqqCcXYhQXRIEoUFIgs6iRY',
                v: '3.20', //defaults to latest 3.X anyhow
                libraries: 'weather,geometry,visualization'
            });
    }

    app.constant('apiBaseUrl', 'http://localhost:9999');
    app.controller('RegieCtrl', Emergen6Controllers.RegieCtrl);
    app.service('RegieService',  Emergen6Services.RegieService);
    app.service('UserService',  Emergen6Services.UserService);
})();