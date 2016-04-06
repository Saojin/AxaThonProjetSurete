'use strict';
var Emergen6Services;
(function (Emergen6Services) {
    var RegieService = (function () {
        RegieService.$inject = ["$window", "$resource", "$http", "apiBaseUrl"];
        function RegieService($window, $resource, $http, apiBaseUrl) {
            'ngInject';
            this.$resource = $resource;
            this.$http = $http;
            this.apiBaseUrl = apiBaseUrl;
            this.socket = $window.io.connect(apiBaseUrl);
        }
        RegieService.prototype.getPositions = function () {
            return this.$http.get(this.apiBaseUrl + '/api/signalements-positions');
        };
        RegieService.prototype.resource = function () {
            return this.$resource(this.apiBaseUrl + '/api/signalements/:id');
        };
        return RegieService;
    }());
    Emergen6Services.RegieService = RegieService;
})(Emergen6Services || (Emergen6Services = {}));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9zZXJ2aWNlL3JlZ2llLXNlcnZpY2UudHMiLCJzcmMvc2VydmljZS9yZWdpZS1zZXJ2aWNlLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUVBO0FBRUEsSUFBTztBQUFQLENBQUEsVUFBTyxrQkFBaUI7O29GQUNwQixJQUFBLGdCQUFBLFlBQUE7UUFHSSxTQUFBLGFBQVksU0FBc0IsV0FBdUIsT0FBcUIsWUFBaUI7WUFDM0Y7WUFEOEIsS0FBQSxZQUFBO1lBQXVCLEtBQUEsUUFBQTtZQUFxQixLQUFBLGFBQUE7WUFHMUUsS0FBSyxTQUFTLFFBQVEsR0FBRyxRQUFROztRQUdyQyxhQUFBLFVBQUEsZUFBQSxZQUFBO1lBQ0ksT0FBTyxLQUFLLE1BQU0sSUFBSSxLQUFLLGFBQVc7O1FBRzFDLGFBQUEsVUFBQSxXQUFBLFlBQUE7WUFDSSxPQUFPLEtBQUssVUFBVSxLQUFLLGFBQVc7O1FBRTlDLE9BQUE7O0lBaEJhLGlCQUFBLGVBQVk7R0FEdEIscUJBQUEsbUJBQWdCO0FDaUJ2QiIsImZpbGUiOiJzcmMvc2VydmljZS9yZWdpZS1zZXJ2aWNlLmpzIiwic291cmNlc0NvbnRlbnQiOlsiLy8vIDxyZWZlcmVuY2UgcGF0aD1cIi4uLy4uL3R5cGluZ3MvdHNkLmQudHNcIiAvPlxuXG4ndXNlIHN0cmljdCc7XG5cbm1vZHVsZSBFbWVyZ2VuNlNlcnZpY2VzIHtcbiAgICBleHBvcnQgY2xhc3MgUmVnaWVTZXJ2aWNlIHtcbiAgICAgICAgcHVibGljIHNvY2tldDphbnk7XG5cbiAgICAgICAgY29uc3RydWN0b3IoJHdpbmRvdyA6IGFueSwgcHVibGljICRyZXNvdXJjZSA6IGFueSxwdWJsaWMgJGh0dHAgOiBhbnksIHByaXZhdGUgYXBpQmFzZVVybDpzdHJpbmcpIHtcbiAgICAgICAgICAgICduZ0luamVjdCc7XG5cbiAgICAgICAgICAgIHRoaXMuc29ja2V0ID0gJHdpbmRvdy5pby5jb25uZWN0KGFwaUJhc2VVcmwpO1xuICAgICAgICB9XG5cbiAgICAgICAgZ2V0UG9zaXRpb25zKCkge1xuICAgICAgICAgICAgcmV0dXJuIHRoaXMuJGh0dHAuZ2V0KHRoaXMuYXBpQmFzZVVybCsnL2FwaS9zaWduYWxlbWVudHMtcG9zaXRpb25zJyk7XG4gICAgICAgIH1cblxuICAgICAgICByZXNvdXJjZSgpIHtcbiAgICAgICAgICAgIHJldHVybiB0aGlzLiRyZXNvdXJjZSh0aGlzLmFwaUJhc2VVcmwrJy9hcGkvc2lnbmFsZW1lbnRzLzppZCcpO1xuICAgICAgICB9XG4gICAgfVxufSIsIid1c2Ugc3RyaWN0JztcbnZhciBFbWVyZ2VuNlNlcnZpY2VzO1xuKGZ1bmN0aW9uIChFbWVyZ2VuNlNlcnZpY2VzKSB7XG4gICAgdmFyIFJlZ2llU2VydmljZSA9IChmdW5jdGlvbiAoKSB7XG4gICAgICAgIGZ1bmN0aW9uIFJlZ2llU2VydmljZSgkd2luZG93LCAkcmVzb3VyY2UsICRodHRwLCBhcGlCYXNlVXJsKSB7XG4gICAgICAgICAgICAnbmdJbmplY3QnO1xuICAgICAgICAgICAgdGhpcy4kcmVzb3VyY2UgPSAkcmVzb3VyY2U7XG4gICAgICAgICAgICB0aGlzLiRodHRwID0gJGh0dHA7XG4gICAgICAgICAgICB0aGlzLmFwaUJhc2VVcmwgPSBhcGlCYXNlVXJsO1xuICAgICAgICAgICAgdGhpcy5zb2NrZXQgPSAkd2luZG93LmlvLmNvbm5lY3QoYXBpQmFzZVVybCk7XG4gICAgICAgIH1cbiAgICAgICAgUmVnaWVTZXJ2aWNlLnByb3RvdHlwZS5nZXRQb3NpdGlvbnMgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICByZXR1cm4gdGhpcy4kaHR0cC5nZXQodGhpcy5hcGlCYXNlVXJsICsgJy9hcGkvc2lnbmFsZW1lbnRzLXBvc2l0aW9ucycpO1xuICAgICAgICB9O1xuICAgICAgICBSZWdpZVNlcnZpY2UucHJvdG90eXBlLnJlc291cmNlID0gZnVuY3Rpb24gKCkge1xuICAgICAgICAgICAgcmV0dXJuIHRoaXMuJHJlc291cmNlKHRoaXMuYXBpQmFzZVVybCArICcvYXBpL3NpZ25hbGVtZW50cy86aWQnKTtcbiAgICAgICAgfTtcbiAgICAgICAgcmV0dXJuIFJlZ2llU2VydmljZTtcbiAgICB9KCkpO1xuICAgIEVtZXJnZW42U2VydmljZXMuUmVnaWVTZXJ2aWNlID0gUmVnaWVTZXJ2aWNlO1xufSkoRW1lcmdlbjZTZXJ2aWNlcyB8fCAoRW1lcmdlbjZTZXJ2aWNlcyA9IHt9KSk7XG4iXSwic291cmNlUm9vdCI6IiJ9
