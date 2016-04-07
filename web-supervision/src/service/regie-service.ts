/// <reference path="../../typings/tsd.d.ts" />

'use strict';

module AxaSafeServices {
    export class RegieService {
        public socket:any;

        constructor($window : any, public $resource : any,public $http : any, private apiBaseUrl:string) {
            'ngInject';

            this.socket = $window.io.connect(apiBaseUrl);
        }

        getPositions() {
            return  this.$http.get(this.apiBaseUrl+'/api/signalements/positions');
        }

        resource() {
            return this.$resource(this.apiBaseUrl+'/api/signalements/:id');
        }
    }
}