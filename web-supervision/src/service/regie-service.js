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
            return this.$http.get(this.apiBaseUrl + '/api/signalements-positions');
        };
        RegieService.prototype.resource = function () {
            return this.$resource(this.apiBaseUrl + '/api/signalements/:id');
        };
        return RegieService;
    }());
    AxaSafeServices.RegieService = RegieService;
})(AxaSafeServices || (AxaSafeServices = {}));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9zZXJ2aWNlL3JlZ2llLXNlcnZpY2UudHMiLCJzcmMvc2VydmljZS9yZWdpZS1zZXJ2aWNlLmpzIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQUVBO0FBRUEsSUFBTztBQUFQLENBQUEsVUFBTyxpQkFBZ0I7O29GQUNuQixJQUFBLGdCQUFBLFlBQUE7UUFHSSxTQUFBLGFBQVksU0FBc0IsV0FBdUIsT0FBcUIsWUFBaUI7WUFDM0Y7WUFEOEIsS0FBQSxZQUFBO1lBQXVCLEtBQUEsUUFBQTtZQUFxQixLQUFBLGFBQUE7WUFHMUUsS0FBSyxTQUFTLFFBQVEsR0FBRyxRQUFROztRQUdyQyxhQUFBLFVBQUEsZUFBQSxZQUFBO1lBQ0ksT0FBTyxLQUFLLE1BQU0sSUFBSSxLQUFLLGFBQVc7O1FBRzFDLGFBQUEsVUFBQSxXQUFBLFlBQUE7WUFDSSxPQUFPLEtBQUssVUFBVSxLQUFLLGFBQVc7O1FBRTlDLE9BQUE7O0lBaEJhLGdCQUFBLGVBQVk7R0FEdEIsb0JBQUEsa0JBQWU7QUNpQnRCIiwiZmlsZSI6InNyYy9zZXJ2aWNlL3JlZ2llLXNlcnZpY2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLy8gPHJlZmVyZW5jZSBwYXRoPVwiLi4vLi4vdHlwaW5ncy90c2QuZC50c1wiIC8+XG5cbid1c2Ugc3RyaWN0JztcblxubW9kdWxlIEF4YVNhZmVTZXJ2aWNlcyB7XG4gICAgZXhwb3J0IGNsYXNzIFJlZ2llU2VydmljZSB7XG4gICAgICAgIHB1YmxpYyBzb2NrZXQ6YW55O1xuXG4gICAgICAgIGNvbnN0cnVjdG9yKCR3aW5kb3cgOiBhbnksIHB1YmxpYyAkcmVzb3VyY2UgOiBhbnkscHVibGljICRodHRwIDogYW55LCBwcml2YXRlIGFwaUJhc2VVcmw6c3RyaW5nKSB7XG4gICAgICAgICAgICAnbmdJbmplY3QnO1xuXG4gICAgICAgICAgICB0aGlzLnNvY2tldCA9ICR3aW5kb3cuaW8uY29ubmVjdChhcGlCYXNlVXJsKTtcbiAgICAgICAgfVxuXG4gICAgICAgIGdldFBvc2l0aW9ucygpIHtcbiAgICAgICAgICAgIHJldHVybiB0aGlzLiRodHRwLmdldCh0aGlzLmFwaUJhc2VVcmwrJy9hcGkvc2lnbmFsZW1lbnRzLXBvc2l0aW9ucycpO1xuICAgICAgICB9XG5cbiAgICAgICAgcmVzb3VyY2UoKSB7XG4gICAgICAgICAgICByZXR1cm4gdGhpcy4kcmVzb3VyY2UodGhpcy5hcGlCYXNlVXJsKycvYXBpL3NpZ25hbGVtZW50cy86aWQnKTtcbiAgICAgICAgfVxuICAgIH1cbn0iLCIndXNlIHN0cmljdCc7XG52YXIgQXhhU2FmZVNlcnZpY2VzO1xuKGZ1bmN0aW9uIChBeGFTYWZlU2VydmljZXMpIHtcbiAgICB2YXIgUmVnaWVTZXJ2aWNlID0gKGZ1bmN0aW9uICgpIHtcbiAgICAgICAgZnVuY3Rpb24gUmVnaWVTZXJ2aWNlKCR3aW5kb3csICRyZXNvdXJjZSwgJGh0dHAsIGFwaUJhc2VVcmwpIHtcbiAgICAgICAgICAgICduZ0luamVjdCc7XG4gICAgICAgICAgICB0aGlzLiRyZXNvdXJjZSA9ICRyZXNvdXJjZTtcbiAgICAgICAgICAgIHRoaXMuJGh0dHAgPSAkaHR0cDtcbiAgICAgICAgICAgIHRoaXMuYXBpQmFzZVVybCA9IGFwaUJhc2VVcmw7XG4gICAgICAgICAgICB0aGlzLnNvY2tldCA9ICR3aW5kb3cuaW8uY29ubmVjdChhcGlCYXNlVXJsKTtcbiAgICAgICAgfVxuICAgICAgICBSZWdpZVNlcnZpY2UucHJvdG90eXBlLmdldFBvc2l0aW9ucyA9IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgICAgIHJldHVybiB0aGlzLiRodHRwLmdldCh0aGlzLmFwaUJhc2VVcmwgKyAnL2FwaS9zaWduYWxlbWVudHMtcG9zaXRpb25zJyk7XG4gICAgICAgIH07XG4gICAgICAgIFJlZ2llU2VydmljZS5wcm90b3R5cGUucmVzb3VyY2UgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICByZXR1cm4gdGhpcy4kcmVzb3VyY2UodGhpcy5hcGlCYXNlVXJsICsgJy9hcGkvc2lnbmFsZW1lbnRzLzppZCcpO1xuICAgICAgICB9O1xuICAgICAgICByZXR1cm4gUmVnaWVTZXJ2aWNlO1xuICAgIH0oKSk7XG4gICAgQXhhU2FmZVNlcnZpY2VzLlJlZ2llU2VydmljZSA9IFJlZ2llU2VydmljZTtcbn0pKEF4YVNhZmVTZXJ2aWNlcyB8fCAoQXhhU2FmZVNlcnZpY2VzID0ge30pKTtcbiJdLCJzb3VyY2VSb290IjoiIn0=
