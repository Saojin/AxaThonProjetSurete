/// <reference path="../../typings/tsd.d.ts" />

'use strict';

describe('app', () => {
    it('créé une application', () => {
        try {
            let app = angular.module('emergen6');
            expect(app).toBeDefined();
            expect(app.controller('regieCtrl')).toBeDefined();
        }
        catch(e) {
            expect(true).toBeFalsy();
        }
    });
});