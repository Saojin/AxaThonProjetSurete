/// <reference path="../typings/tsd.d.ts" />

'use strict';

(() => {
    var app:ng.IModule = angular.module('axasafe', ['ngMaterial','ngRoute','uiGmapgoogle-maps','ngResource']);
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

    app.constant('apiBaseUrl', 'http://team18-axasafe.azurewebsites.net');
    app.controller('RegieCtrl', AxaSafeControllers.RegieCtrl);
    app.service('RegieService',  AxaSafeServices.RegieService);
    app.service('UserService',  AxaSafeServices.UserService);
})();