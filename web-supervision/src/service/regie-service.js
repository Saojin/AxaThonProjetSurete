'use strict';
var AxaSafeServices;
(function (AxaSafeServices) {
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
            return this.$http.get(this.apiBaseUrl + '/api/signalements/positions');
        };
        RegieService.prototype.resource = function () {
            return this.$resource(this.apiBaseUrl + '/api/signalements/:id');
        };
        return RegieService;
    }());
    AxaSafeServices.RegieService = RegieService;
})(AxaSafeServices || (AxaSafeServices = {}));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9zZXJ2aWNlL3JlZ2llLXNlcnZpY2UudHMiLCJzcmMvc2VydmljZS9yZWdpZS1zZXJ2aWNlLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUVBO0FBRUEsSUFBTztBQUFQLENBQUEsVUFBTyxpQkFBZ0I7O29GQUNuQixJQUFBLGdCQUFBLFlBQUE7UUFHSSxTQUFBLGFBQVksU0FBc0IsV0FBdUIsT0FBcUIsWUFBaUI7WUFDM0Y7WUFEOEIsS0FBQSxZQUFBO1lBQXVCLEtBQUEsUUFBQTtZQUFxQixLQUFBLGFBQUE7WUFHMUUsS0FBSyxTQUFTLFFBQVEsR0FBRyxRQUFROztRQUdyQyxhQUFBLFVBQUEsZUFBQSxZQUFBO1lBQ0ksT0FBUSxLQUFLLE1BQU0sSUFBSSxLQUFLLGFBQVc7O1FBRzNDLGFBQUEsVUFBQSxXQUFBLFlBQUE7WUFDSSxPQUFPLEtBQUssVUFBVSxLQUFLLGFBQVc7O1FBRTlDLE9BQUE7O0lBaEJhLGdCQUFBLGVBQVk7R0FEdEIsb0JBQUEsa0JBQWU7QUNpQnRCIiwiZmlsZSI6InNyYy9zZXJ2aWNlL3JlZ2llLXNlcnZpY2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLy8gPHJlZmVyZW5jZSBwYXRoPVwiLi4vLi4vdHlwaW5ncy90c2QuZC50c1wiIC8+XG5cbid1c2Ugc3RyaWN0JztcblxubW9kdWxlIEF4YVNhZmVTZXJ2aWNlcyB7XG4gICAgZXhwb3J0IGNsYXNzIFJlZ2llU2VydmljZSB7XG4gICAgICAgIHB1YmxpYyBzb2NrZXQ6YW55O1xuXG4gICAgICAgIGNvbnN0cnVjdG9yKCR3aW5kb3cgOiBhbnksIHB1YmxpYyAkcmVzb3VyY2UgOiBhbnkscHVibGljICRodHRwIDogYW55LCBwcml2YXRlIGFwaUJhc2VVcmw6c3RyaW5nKSB7XG4gICAgICAgICAgICAnbmdJbmplY3QnO1xuXG4gICAgICAgICAgICB0aGlzLnNvY2tldCA9ICR3aW5kb3cuaW8uY29ubmVjdChhcGlCYXNlVXJsKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGdldFBvc2l0aW9ucygpIHtcbiAgICAgICAgICAgIHJldHVybiAgdGhpcy4kaHR0cC5nZXQodGhpcy5hcGlCYXNlVXJsKycvYXBpL3NpZ25hbGVtZW50cy9wb3NpdGlvbnMnKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHJlc291cmNlKCkge1xuICAgICAgICAgICAgcmV0dXJuIHRoaXMuJHJlc291cmNlKHRoaXMuYXBpQmFzZVVybCsnL2FwaS9zaWduYWxlbWVudHMvOmlkJyk7XG4gICAgICAgIH1cbiAgICB9XG59IiwiJ3VzZSBzdHJpY3QnO1xudmFyIEF4YVNhZmVTZXJ2aWNlcztcbihmdW5jdGlvbiAoQXhhU2FmZVNlcnZpY2VzKSB7XG4gICAgdmFyIFJlZ2llU2VydmljZSA9IChmdW5jdGlvbiAoKSB7XG4gICAgICAgIGZ1bmN0aW9uIFJlZ2llU2VydmljZSgkd2luZG93LCAkcmVzb3VyY2UsICRodHRwLCBhcGlCYXNlVXJsKSB7XG4gICAgICAgICAgICAnbmdJbmplY3QnO1xuICAgICAgICAgICAgdGhpcy4kcmVzb3VyY2UgPSAkcmVzb3VyY2U7XG4gICAgICAgICAgICB0aGlzLiRodHRwID0gJGh0dHA7XG4gICAgICAgICAgICB0aGlzLmFwaUJhc2VVcmwgPSBhcGlCYXNlVXJsO1xuICAgICAgICAgICAgdGhpcy5zb2NrZXQgPSAkd2luZG93LmlvLmNvbm5lY3QoYXBpQmFzZVVybCk7XG4gICAgICAgIH1cbiAgICAgICAgUmVnaWVTZXJ2aWNlLnByb3RvdHlwZS5nZXRQb3NpdGlvbnMgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICByZXR1cm4gdGhpcy4kaHR0cC5nZXQodGhpcy5hcGlCYXNlVXJsICsgJy9hcGkvc2lnbmFsZW1lbnRzL3Bvc2l0aW9ucycpO1xuICAgICAgICB9O1xuICAgICAgICBSZWdpZVNlcnZpY2UucHJvdG90eXBlLnJlc291cmNlID0gZnVuY3Rpb24gKCkge1xuICAgICAgICAgICAgcmV0dXJuIHRoaXMuJHJlc291cmNlKHRoaXMuYXBpQmFzZVVybCArICcvYXBpL3NpZ25hbGVtZW50cy86aWQnKTtcbiAgICAgICAgfTtcbiAgICAgICAgcmV0dXJuIFJlZ2llU2VydmljZTtcbiAgICB9KCkpO1xuICAgIEF4YVNhZmVTZXJ2aWNlcy5SZWdpZVNlcnZpY2UgPSBSZWdpZVNlcnZpY2U7XG59KShBeGFTYWZlU2VydmljZXMgfHwgKEF4YVNhZmVTZXJ2aWNlcyA9IHt9KSk7XG4iXSwic291cmNlUm9vdCI6IiJ9
