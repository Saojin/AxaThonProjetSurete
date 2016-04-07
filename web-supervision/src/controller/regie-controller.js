'use strict';
var AxaSafeControllers;
(function (AxaSafeControllers) {
    var RegieCtrl = (function () {
        RegieCtrl.$inject = ["$scope", "uiGmapGoogleMapApi", "RegieService", "UserService", "$interval"];
        function RegieCtrl($scope, uiGmapGoogleMapApi, RegieService, UserService, $interval) {
            'ngInject';
            var _this = this;
            this.$scope = $scope;
            this.RegieService = RegieService;
            this.UserService = UserService;
            this.fk = {};
            this.isLoading = true;
            uiGmapGoogleMapApi.then(function (maps) {
                if (typeof _.contains === 'undefined') {
                    _.contains = _.includes;
                }
                if (typeof _.object === 'undefined') {
                    _.object = _.zipObject;
                }
                maps.visualRefresh = true;
                RegieService.getPositions().then(function (response) {
                    _this.isLoading = false;
                    response.data.forEach(function (signalement) {
                        if (!signalement.hasMeta)
                            signalement.icon = 'src/img/no-info.png';
                        else
                            signalement.icon = 'src/img/info.png';
                        signalement.click = function () {
                            if (!!signalement.hasMeta)
                                _this.showDetails(signalement);
                            else
                                _this.currentPoint = null;
                        };
                        _this.map.pointList.push(signalement);
                    });
                });
            });
            this.map = { center: { latitude: 48.8965812, longitude: 2.318375999999944 }, zoom: 13, pointList: [], options: { streetViewControl: false } };
            RegieService.socket.on('nouveau-signalement', function (signalement) {
                signalement.options = { animation: 2 };
                if (!signalement.hasMeta)
                    signalement.icon = 'src/img/no-info.png';
                else
                    signalement.icon = 'src/img/info.png';
                signalement.click = function () {
                    if (!!signalement.hasMeta)
                        _this.showDetails(signalement);
                    else
                        _this.currentPoint = null;
                };
                _this.map.pointList.push(signalement);
                _this.$scope.$apply();
            });
        }
        RegieCtrl.prototype.showDetails = function (point) {
            var _this = this;
            this.isLoading = true;
            this.currentPoint = null;
            this.RegieService.resource().get({ id: point.id }).$promise.then(function (data) {
                _this.UserService.get({ id: data.userid }).$promise.then(function (userData) {
                    data.utilisateur = userData;
                    _this.currentPoint = data;
                    _this.isLoading = false;
                    console.log(_this.currentPoint);
                }, function () {
                    _this.currentPoint = data;
                    _this.isLoading = false;
                });
            });
            this.$scope.$apply();
        };
        RegieCtrl.prototype.searchAddress = function (filter) {
        };
        return RegieCtrl;
    }());
    AxaSafeControllers.RegieCtrl = RegieCtrl;
})(AxaSafeControllers || (AxaSafeControllers = {}));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9jb250cm9sbGVyL3JlZ2llLWNvbnRyb2xsZXIudHMiLCJzcmMvY29udHJvbGxlci9yZWdpZS1jb250cm9sbGVyLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUVBO0FBSUEsSUFBTztBQUFQLENBQUEsVUFBTyxvQkFBbUI7OzhHQUN0QixJQUFBLGFBQUEsWUFBQTtRQVVJLFNBQUEsVUFBbUIsUUFBa0Isb0JBQStCLGNBQXlCLGFBQWlCLFdBQWE7WUFDdkg7WUFYUixJQUFBLFFBQUE7WUFVdUIsS0FBQSxTQUFBO1lBQWlELEtBQUEsZUFBQTtZQUF5QixLQUFBLGNBQUE7WUFOdEYsS0FBQSxLQUFTO1lBQ1QsS0FBQSxZQUFvQjtZQVF2QixtQkFBbUIsS0FBSyxVQUFDLE1BQVE7Z0JBRTdCLElBQUksT0FBTyxFQUFFLGFBQWEsYUFBYztvQkFDcEMsRUFBRSxXQUFXLEVBQUU7O2dCQUVuQixJQUFJLE9BQU8sRUFBRSxXQUFXLGFBQWM7b0JBQ2xDLEVBQUUsU0FBUyxFQUFFOztnQkFFaEIsS0FBSyxnQkFBZ0I7Z0JBR3JCLGFBQWEsZUFBZSxLQUFLLFVBQUMsVUFBWTtvQkFFekMsTUFBSyxZQUFZO29CQUVqQixTQUFTLEtBQUssUUFBUSxVQUFDLGFBQWU7d0JBQ2xDLElBQUcsQ0FBQyxZQUFZOzRCQUNkLFlBQVksT0FBTzs7NEJBRW5CLFlBQVksT0FBTzt3QkFFckIsWUFBWSxRQUFTLFlBQUE7NEJBQ2pCLElBQUcsQ0FBQyxDQUFDLFlBQVk7Z0NBQ2pCLE1BQUssWUFBWTs7Z0NBRWpCLE1BQUssZUFBZTs7d0JBRXhCLE1BQUssSUFBSSxVQUFVLEtBQUs7Ozs7WUFLdEMsS0FBSyxNQUFPLEVBQUMsUUFBUSxFQUFFLFVBQVUsWUFBWSxXQUFXLHFCQUFxQixNQUFNLElBQUksV0FBVyxJQUFJLFNBQVMsRUFBQyxtQkFBbUI7WUFJbkksYUFBYSxPQUFPLEdBQUcsdUJBQXVCLFVBQUMsYUFBZTtnQkFDNUQsWUFBWSxVQUFVLEVBQUMsV0FBVztnQkFDaEMsSUFBRyxDQUFDLFlBQVk7b0JBQ1osWUFBWSxPQUFPOztvQkFFbkIsWUFBWSxPQUFPO2dCQUV0QixZQUFZLFFBQVMsWUFBQTtvQkFDaEIsSUFBRyxDQUFDLENBQUMsWUFBWTt3QkFDYixNQUFLLFlBQVk7O3dCQUVqQixNQUFLLGVBQWU7O2dCQUVoQyxNQUFLLElBQUksVUFBVSxLQUFLO2dCQUN4QixNQUFLLE9BQU87OztRQUlsQixVQUFBLFVBQUEsY0FBQSxVQUFZLE9BQVM7WUFBckIsSUFBQSxRQUFBO1lBQ0UsS0FBSyxZQUFZO1lBQ2pCLEtBQUssZUFBZTtZQUNwQixLQUFLLGFBQWEsV0FBVyxJQUFJLEVBQUMsSUFBSSxNQUFNLE1BQUssU0FBUyxLQUFLLFVBQUMsTUFBUTtnQkFDdEUsTUFBSyxZQUFZLElBQUksRUFBQyxJQUFJLEtBQUssVUFBUyxTQUFTLEtBQUssVUFBQyxVQUFZO29CQUNqRSxLQUFLLGNBQWM7b0JBQ25CLE1BQUssZUFBZTtvQkFDcEIsTUFBSyxZQUFZO29CQUNqQixRQUFRLElBQUksTUFBSzttQkFDakIsWUFBQTtvQkFBTSxNQUFLLGVBQWU7b0JBQzFCLE1BQUssWUFBWTs7O1lBRXJCLEtBQUssT0FBTzs7UUFHZCxVQUFBLFVBQUEsZ0JBQUEsVUFBYyxRQUFhOztRQUcvQixPQUFBOztJQXJGYSxtQkFBQSxZQUFTO0dBRG5CLHVCQUFBLHFCQUFrQjtBQ3VFekIiLCJmaWxlIjoic3JjL2NvbnRyb2xsZXIvcmVnaWUtY29udHJvbGxlci5qcyIsInNvdXJjZXNDb250ZW50IjpbIi8vLyA8cmVmZXJlbmNlIHBhdGg9XCIuLi8uLi90eXBpbmdzL3RzZC5kLnRzXCIgLz5cblxuJ3VzZSBzdHJpY3QnO1xuXG5kZWNsYXJlIHZhciBfOmFueTsgLy8gaGFja3kgaGFja3kgXl5cblxubW9kdWxlIEF4YVNhZmVDb250cm9sbGVycyB7XG4gICAgZXhwb3J0IGNsYXNzIFJlZ2llQ3RybCB7XG5cbiAgICAgICAgcHVibGljIGN1cnJlbnRQb2ludDphbnk7XG4gICAgICAgIHB1YmxpYyBtYXA6YW55O1xuICAgICAgICBwdWJsaWMgZms6YW55ID0ge307XG4gICAgICAgIHB1YmxpYyBpc0xvYWRpbmc6Ym9vbGVhbiA9IHRydWU7XG4gICAgICAgIHB1YmxpYyBzZWFyY2hib3g6YW55O1xuICAgICAgICBwdWJsaWMgc2VhcmNoU3RyaW5nOnN0cmluZztcblxuXG4gICAgICAgIGNvbnN0cnVjdG9yKHB1YmxpYyAkc2NvcGU6bmcuSVNjb3BlLCB1aUdtYXBHb29nbGVNYXBBcGk6YW55LCBwdWJsaWMgUmVnaWVTZXJ2aWNlOmFueSwgcHVibGljIFVzZXJTZXJ2aWNlOmFueSwgJGludGVydmFsOmFueSkge1xuICAgICAgICAgICAgJ25nSW5qZWN0JztcblxuICAgICAgICAgICAgdWlHbWFwR29vZ2xlTWFwQXBpLnRoZW4oKG1hcHM6YW55KSA9PiB7XG4gICAgICAgICAgICAgICAgLy8gbG9kYXNoIGVzdCBww6l0w6lcbiAgICAgICAgICAgICAgICBpZiggdHlwZW9mIF8uY29udGFpbnMgPT09ICd1bmRlZmluZWQnICkge1xuICAgICAgICAgICAgICAgICAgICBfLmNvbnRhaW5zID0gXy5pbmNsdWRlcztcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgaWYoIHR5cGVvZiBfLm9iamVjdCA9PT0gJ3VuZGVmaW5lZCcgKSB7XG4gICAgICAgICAgICAgICAgICAgIF8ub2JqZWN0ID0gXy56aXBPYmplY3Q7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICBtYXBzLnZpc3VhbFJlZnJlc2ggPSB0cnVlO1xuXG4gICAgICAgICAgICAgICAgLy90aGlzLmlzTG9hZGluZyA9IGZhbHNlO1xuICAgICAgICAgICAgICAgICBSZWdpZVNlcnZpY2UuZ2V0UG9zaXRpb25zKCkudGhlbigocmVzcG9uc2U6YW55KSA9PiB7XG5cbiAgICAgICAgICAgICAgICAgICAgICB0aGlzLmlzTG9hZGluZyA9IGZhbHNlO1xuXG4gICAgICAgICAgICAgICAgICAgICAgcmVzcG9uc2UuZGF0YS5mb3JFYWNoKChzaWduYWxlbWVudDphbnkpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgaWYoIXNpZ25hbGVtZW50Lmhhc01ldGEpXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuaWNvbiA9ICdzcmMvaW1nL25vLWluZm8ucG5nJztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgZWxzZVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpZ25hbGVtZW50Lmljb24gPSAnc3JjL2ltZy9pbmZvLnBuZyc7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuY2xpY2sgPSAgKCk9PiB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZighIXNpZ25hbGVtZW50Lmhhc01ldGEpXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0aGlzLnNob3dEZXRhaWxzKHNpZ25hbGVtZW50KTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRoaXMuY3VycmVudFBvaW50ID0gbnVsbDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgfTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgdGhpcy5tYXAucG9pbnRMaXN0LnB1c2goc2lnbmFsZW1lbnQpO1xuICAgICAgICAgICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH0pO1xuXG4gICAgICAgICAgICB0aGlzLm1hcCA9ICB7Y2VudGVyOiB7IGxhdGl0dWRlOiA0OC44OTY1ODEyLCBsb25naXR1ZGU6IDIuMzE4Mzc1OTk5OTk5OTQ0IH0sIHpvb206IDEzLCBwb2ludExpc3Q6IFtdLCBvcHRpb25zOiB7c3RyZWV0Vmlld0NvbnRyb2w6IGZhbHNlfX07XG5cblxuXG4gICAgICAgICAgICBSZWdpZVNlcnZpY2Uuc29ja2V0Lm9uKCdub3V2ZWF1LXNpZ25hbGVtZW50JywgKHNpZ25hbGVtZW50OmFueSkgPT4ge1xuICAgICAgICAgICAgICBzaWduYWxlbWVudC5vcHRpb25zID0ge2FuaW1hdGlvbjogMn07XG4gICAgICAgICAgICAgICAgaWYoIXNpZ25hbGVtZW50Lmhhc01ldGEpXG4gICAgICAgICAgICAgICAgICAgIHNpZ25hbGVtZW50Lmljb24gPSAnc3JjL2ltZy9uby1pbmZvLnBuZyc7XG4gICAgICAgICAgICAgICAgZWxzZVxuICAgICAgICAgICAgICAgICAgICBzaWduYWxlbWVudC5pY29uID0gJ3NyYy9pbWcvaW5mby5wbmcnO1xuXG4gICAgICAgICAgICAgICAgIHNpZ25hbGVtZW50LmNsaWNrID0gICgpPT4ge1xuICAgICAgICAgICAgICAgICAgICAgIGlmKCEhc2lnbmFsZW1lbnQuaGFzTWV0YSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgdGhpcy5zaG93RGV0YWlscyhzaWduYWxlbWVudCk7XG4gICAgICAgICAgICAgICAgICAgICAgZWxzZVxuICAgICAgICAgICAgICAgICAgICAgICAgICB0aGlzLmN1cnJlbnRQb2ludCA9IG51bGw7XG4gICAgICAgICAgICB9O1xuICAgICAgICAgICAgICB0aGlzLm1hcC5wb2ludExpc3QucHVzaChzaWduYWxlbWVudCk7XG4gICAgICAgICAgICAgIHRoaXMuJHNjb3BlLiRhcHBseSgpO1xuICAgICAgICAgICAgfSk7XG4gICAgICAgIH1cblxuICAgICAgICBzaG93RGV0YWlscyhwb2ludDphbnkpIHtcbiAgICAgICAgICB0aGlzLmlzTG9hZGluZyA9IHRydWU7XG4gICAgICAgICAgdGhpcy5jdXJyZW50UG9pbnQgPSBudWxsO1xuICAgICAgICAgIHRoaXMuUmVnaWVTZXJ2aWNlLnJlc291cmNlKCkuZ2V0KHtpZDogcG9pbnQuaWR9KS4kcHJvbWlzZS50aGVuKChkYXRhOmFueSkgPT4ge1xuICAgICAgICAgICAgdGhpcy5Vc2VyU2VydmljZS5nZXQoe2lkOiBkYXRhLnVzZXJpZH0pLiRwcm9taXNlLnRoZW4oKHVzZXJEYXRhOmFueSkgPT4ge1xuICAgICAgICAgICAgICBkYXRhLnV0aWxpc2F0ZXVyID0gdXNlckRhdGE7XG4gICAgICAgICAgICAgIHRoaXMuY3VycmVudFBvaW50ID0gZGF0YTtcbiAgICAgICAgICAgICAgdGhpcy5pc0xvYWRpbmcgPSBmYWxzZTtcbiAgICAgICAgICAgICAgY29uc29sZS5sb2codGhpcy5jdXJyZW50UG9pbnQpO1xuICAgICAgICAgICAgfSwoKT0+eyB0aGlzLmN1cnJlbnRQb2ludCA9IGRhdGE7XG4gICAgICAgICAgICAgIHRoaXMuaXNMb2FkaW5nID0gZmFsc2U7fSk7XG4gICAgICAgICAgfSk7XG4gICAgICAgICAgdGhpcy4kc2NvcGUuJGFwcGx5KCk7XG4gICAgICAgIH1cblxuICAgICAgICBzZWFyY2hBZGRyZXNzKGZpbHRlcjpzdHJpbmcpIHtcbiAgICAgICAgICAgIC8vdGhpcy5tYXAucGFuVG8oKVxuICAgICAgICB9XG4gICAgfVxufVxuIiwiJ3VzZSBzdHJpY3QnO1xudmFyIEF4YVNhZmVDb250cm9sbGVycztcbihmdW5jdGlvbiAoQXhhU2FmZUNvbnRyb2xsZXJzKSB7XG4gICAgdmFyIFJlZ2llQ3RybCA9IChmdW5jdGlvbiAoKSB7XG4gICAgICAgIGZ1bmN0aW9uIFJlZ2llQ3RybCgkc2NvcGUsIHVpR21hcEdvb2dsZU1hcEFwaSwgUmVnaWVTZXJ2aWNlLCBVc2VyU2VydmljZSwgJGludGVydmFsKSB7XG4gICAgICAgICAgICAnbmdJbmplY3QnO1xuICAgICAgICAgICAgdmFyIF90aGlzID0gdGhpcztcbiAgICAgICAgICAgIHRoaXMuJHNjb3BlID0gJHNjb3BlO1xuICAgICAgICAgICAgdGhpcy5SZWdpZVNlcnZpY2UgPSBSZWdpZVNlcnZpY2U7XG4gICAgICAgICAgICB0aGlzLlVzZXJTZXJ2aWNlID0gVXNlclNlcnZpY2U7XG4gICAgICAgICAgICB0aGlzLmZrID0ge307XG4gICAgICAgICAgICB0aGlzLmlzTG9hZGluZyA9IHRydWU7XG4gICAgICAgICAgICB1aUdtYXBHb29nbGVNYXBBcGkudGhlbihmdW5jdGlvbiAobWFwcykge1xuICAgICAgICAgICAgICAgIGlmICh0eXBlb2YgXy5jb250YWlucyA9PT0gJ3VuZGVmaW5lZCcpIHtcbiAgICAgICAgICAgICAgICAgICAgXy5jb250YWlucyA9IF8uaW5jbHVkZXM7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGlmICh0eXBlb2YgXy5vYmplY3QgPT09ICd1bmRlZmluZWQnKSB7XG4gICAgICAgICAgICAgICAgICAgIF8ub2JqZWN0ID0gXy56aXBPYmplY3Q7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIG1hcHMudmlzdWFsUmVmcmVzaCA9IHRydWU7XG4gICAgICAgICAgICAgICAgUmVnaWVTZXJ2aWNlLmdldFBvc2l0aW9ucygpLnRoZW4oZnVuY3Rpb24gKHJlc3BvbnNlKSB7XG4gICAgICAgICAgICAgICAgICAgIF90aGlzLmlzTG9hZGluZyA9IGZhbHNlO1xuICAgICAgICAgICAgICAgICAgICByZXNwb25zZS5kYXRhLmZvckVhY2goZnVuY3Rpb24gKHNpZ25hbGVtZW50KSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAoIXNpZ25hbGVtZW50Lmhhc01ldGEpXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuaWNvbiA9ICdzcmMvaW1nL25vLWluZm8ucG5nJztcbiAgICAgICAgICAgICAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBzaWduYWxlbWVudC5pY29uID0gJ3NyYy9pbWcvaW5mby5wbmcnO1xuICAgICAgICAgICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuY2xpY2sgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCEhc2lnbmFsZW1lbnQuaGFzTWV0YSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX3RoaXMuc2hvd0RldGFpbHMoc2lnbmFsZW1lbnQpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX3RoaXMuY3VycmVudFBvaW50ID0gbnVsbDtcbiAgICAgICAgICAgICAgICAgICAgICAgIH07XG4gICAgICAgICAgICAgICAgICAgICAgICBfdGhpcy5tYXAucG9pbnRMaXN0LnB1c2goc2lnbmFsZW1lbnQpO1xuICAgICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgdGhpcy5tYXAgPSB7IGNlbnRlcjogeyBsYXRpdHVkZTogNDguODk2NTgxMiwgbG9uZ2l0dWRlOiAyLjMxODM3NTk5OTk5OTk0NCB9LCB6b29tOiAxMywgcG9pbnRMaXN0OiBbXSwgb3B0aW9uczogeyBzdHJlZXRWaWV3Q29udHJvbDogZmFsc2UgfSB9O1xuICAgICAgICAgICAgUmVnaWVTZXJ2aWNlLnNvY2tldC5vbignbm91dmVhdS1zaWduYWxlbWVudCcsIGZ1bmN0aW9uIChzaWduYWxlbWVudCkge1xuICAgICAgICAgICAgICAgIHNpZ25hbGVtZW50Lm9wdGlvbnMgPSB7IGFuaW1hdGlvbjogMiB9O1xuICAgICAgICAgICAgICAgIGlmICghc2lnbmFsZW1lbnQuaGFzTWV0YSlcbiAgICAgICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuaWNvbiA9ICdzcmMvaW1nL25vLWluZm8ucG5nJztcbiAgICAgICAgICAgICAgICBlbHNlXG4gICAgICAgICAgICAgICAgICAgIHNpZ25hbGVtZW50Lmljb24gPSAnc3JjL2ltZy9pbmZvLnBuZyc7XG4gICAgICAgICAgICAgICAgc2lnbmFsZW1lbnQuY2xpY2sgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICAgICAgICAgIGlmICghIXNpZ25hbGVtZW50Lmhhc01ldGEpXG4gICAgICAgICAgICAgICAgICAgICAgICBfdGhpcy5zaG93RGV0YWlscyhzaWduYWxlbWVudCk7XG4gICAgICAgICAgICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgICAgICAgICAgICAgIF90aGlzLmN1cnJlbnRQb2ludCA9IG51bGw7XG4gICAgICAgICAgICAgICAgfTtcbiAgICAgICAgICAgICAgICBfdGhpcy5tYXAucG9pbnRMaXN0LnB1c2goc2lnbmFsZW1lbnQpO1xuICAgICAgICAgICAgICAgIF90aGlzLiRzY29wZS4kYXBwbHkoKTtcbiAgICAgICAgICAgIH0pO1xuICAgICAgICB9XG4gICAgICAgIFJlZ2llQ3RybC5wcm90b3R5cGUuc2hvd0RldGFpbHMgPSBmdW5jdGlvbiAocG9pbnQpIHtcbiAgICAgICAgICAgIHZhciBfdGhpcyA9IHRoaXM7XG4gICAgICAgICAgICB0aGlzLmlzTG9hZGluZyA9IHRydWU7XG4gICAgICAgICAgICB0aGlzLmN1cnJlbnRQb2ludCA9IG51bGw7XG4gICAgICAgICAgICB0aGlzLlJlZ2llU2VydmljZS5yZXNvdXJjZSgpLmdldCh7IGlkOiBwb2ludC5pZCB9KS4kcHJvbWlzZS50aGVuKGZ1bmN0aW9uIChkYXRhKSB7XG4gICAgICAgICAgICAgICAgX3RoaXMuVXNlclNlcnZpY2UuZ2V0KHsgaWQ6IGRhdGEudXNlcmlkIH0pLiRwcm9taXNlLnRoZW4oZnVuY3Rpb24gKHVzZXJEYXRhKSB7XG4gICAgICAgICAgICAgICAgICAgIGRhdGEudXRpbGlzYXRldXIgPSB1c2VyRGF0YTtcbiAgICAgICAgICAgICAgICAgICAgX3RoaXMuY3VycmVudFBvaW50ID0gZGF0YTtcbiAgICAgICAgICAgICAgICAgICAgX3RoaXMuaXNMb2FkaW5nID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKF90aGlzLmN1cnJlbnRQb2ludCk7XG4gICAgICAgICAgICAgICAgfSwgZnVuY3Rpb24gKCkge1xuICAgICAgICAgICAgICAgICAgICBfdGhpcy5jdXJyZW50UG9pbnQgPSBkYXRhO1xuICAgICAgICAgICAgICAgICAgICBfdGhpcy5pc0xvYWRpbmcgPSBmYWxzZTtcbiAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgdGhpcy4kc2NvcGUuJGFwcGx5KCk7XG4gICAgICAgIH07XG4gICAgICAgIFJlZ2llQ3RybC5wcm90b3R5cGUuc2VhcmNoQWRkcmVzcyA9IGZ1bmN0aW9uIChmaWx0ZXIpIHtcbiAgICAgICAgfTtcbiAgICAgICAgcmV0dXJuIFJlZ2llQ3RybDtcbiAgICB9KCkpO1xuICAgIEF4YVNhZmVDb250cm9sbGVycy5SZWdpZUN0cmwgPSBSZWdpZUN0cmw7XG59KShBeGFTYWZlQ29udHJvbGxlcnMgfHwgKEF4YVNhZmVDb250cm9sbGVycyA9IHt9KSk7XG4iXSwic291cmNlUm9vdCI6IiJ9
