/// <reference path="../../typings/tsd.d.ts" />

'use strict';

module AxaSafeServices {
    export function UserService($resource:any, apiBaseUrl: any) {
        'ngInject';
        return $resource(apiBaseUrl + '/api/utilisateurs/:id');
    }
}