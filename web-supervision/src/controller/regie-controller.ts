/// <reference path="../../typings/tsd.d.ts" />

'use strict';

declare var _:any; // hacky hacky ^^

module Emergen6Controllers {
  export class RegieCtrl {
        
        public currentPoint:any;
        public map:any;
        public fk:any = {};
        public isLoading:boolean = true;

        constructor(public $scope:ng.IScope, uiGmapGoogleMapApi:any, public RegieService:any, public UserService:any, $interval:any) {
            'ngInject';

            uiGmapGoogleMapApi.then((maps:any) => {
                // lodash est pété
                if( typeof _.contains === 'undefined' ) {
                    _.contains = _.includes;
                }
                if( typeof _.object === 'undefined' ) {
                    _.object = _.zipObject;
                }
                 maps.visualRefresh = true;

                 RegieService.getPositions().then((response:any) => {
                     this.fk.data1 = Math.ceil(Math.random()*234);
                     this.fk.data2 = Math.ceil(Math.random()*932);
                     this.fk.data3 = Math.ceil(Math.random()*534);
                     this.fk.data4 = Math.ceil(Math.random()*16);
                      this.isLoading = false;

                      response.data.forEach((signalement:any) => {
                          if(!signalement.hasMeta)
                    signalement.icon = 'src/img/no-info.png';
                    else
                    signalement.icon = 'src/img/info.png';
                
                          signalement.click =  ()=> {
                              if(!!signalement.hasMeta)   
                              this.showDetails(signalement);
                              else
                              this.currentPoint = null;
                          };
                          this.map.pointList.push(signalement);
                      });
                     $interval(() => {
                       this.fk.data1 = Math.ceil(Math.random()*234);
                     }, 1000 + Math.random() * 2500);
                     $interval(() => {
                       this.fk.data2 = Math.ceil(Math.random()*932);
                     }, 1000 + Math.random() * 2500);
                     $interval(() => {
                       this.fk.data3 = Math.ceil(Math.random()*534);
                     }, 1000 + Math.random() * 2500);
                     $interval(() => {
                       this.fk.data4 = Math.ceil(Math.random()*16);
                     }, 1000 + Math.random() * 2500);
                 });
            });
            
            this.map =  {center: { latitude: 48.8965812, longitude: 2.318375999999944 }, zoom: 13, pointList: [], options: {streetViewControl: false}};
            

            RegieService.socket.on('nouveau-signalement', (signalement:any) => {
              signalement.options = {animation: 2};
                if(!signalement.hasMeta)
                    signalement.icon = 'src/img/no-info.png';
                    else
                    signalement.icon = 'src/img/info.png';
                    
                 signalement.click =  ()=> {   
                      if(!!signalement.hasMeta)   
                              this.showDetails(signalement);
                              else
                              this.currentPoint = null;
            };
              this.map.pointList.push(signalement);
              this.$scope.$apply();
            });
        }
        
        showDetails(point:any) {
          this.isLoading = true;
          this.currentPoint = null;
          this.RegieService.resource().get({id: point.id}).$promise.then((data:any) => {
            this.UserService.get({id: data.userid}).$promise.then((userData:any) => {
              data.utilisateur = userData;
              this.currentPoint = data;
              this.isLoading = false;
              console.log(this.currentPoint);
            },()=>{ this.currentPoint = data;
              this.isLoading = false;});
          });
          this.$scope.$apply();
        }
    }
}
