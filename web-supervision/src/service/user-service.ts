/// <reference path="../../typings/tsd.d.ts" />

'use strict';

module Emergen6Services {
    export function UserService($resource:any, apiBaseUrl: any) {
        'ngInject';
        return $resource(apiBaseUrl + '/api/utilisateurs/:id');
    }
}