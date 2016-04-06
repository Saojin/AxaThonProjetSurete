'use strict';
var AxaSafeServices;
(function (AxaSafeServices) {
    UserService.$inject = ["$resource", "apiBaseUrl"];
    function UserService($resource, apiBaseUrl) {
        'ngInject';
        return $resource(apiBaseUrl + '/api/utilisateurs/:id');
    }
    AxaSafeServices.UserService = UserService;
})(AxaSafeServices || (AxaSafeServices = {}));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbInNyYy9zZXJ2aWNlL3VzZXItc2VydmljZS50cyIsInNyYy9zZXJ2aWNlL3VzZXItc2VydmljZS5qcyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFFQTtBQUVBLElBQU87O3VEQUFQLENBQUEsVUFBTyxpQkFBZ0I7SUFDbkIsU0FBQSxZQUE0QixXQUFlLFlBQWU7UUFDdEQ7UUFDQSxPQUFPLFVBQVUsYUFBYTs7SUFGbEIsZ0JBQUEsY0FBVztHQUR4QixvQkFBQSxrQkFBZTtBQ0t0QiIsImZpbGUiOiJzcmMvc2VydmljZS91c2VyLXNlcnZpY2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLy8gPHJlZmVyZW5jZSBwYXRoPVwiLi4vLi4vdHlwaW5ncy90c2QuZC50c1wiIC8+XG5cbid1c2Ugc3RyaWN0JztcblxubW9kdWxlIEF4YVNhZmVTZXJ2aWNlcyB7XG4gICAgZXhwb3J0IGZ1bmN0aW9uIFVzZXJTZXJ2aWNlKCRyZXNvdXJjZTphbnksIGFwaUJhc2VVcmw6IGFueSkge1xuICAgICAgICAnbmdJbmplY3QnO1xuICAgICAgICByZXR1cm4gJHJlc291cmNlKGFwaUJhc2VVcmwgKyAnL2FwaS91dGlsaXNhdGV1cnMvOmlkJyk7XG4gICAgfVxufSIsIid1c2Ugc3RyaWN0JztcbnZhciBBeGFTYWZlU2VydmljZXM7XG4oZnVuY3Rpb24gKEF4YVNhZmVTZXJ2aWNlcykge1xuICAgIGZ1bmN0aW9uIFVzZXJTZXJ2aWNlKCRyZXNvdXJjZSwgYXBpQmFzZVVybCkge1xuICAgICAgICAnbmdJbmplY3QnO1xuICAgICAgICByZXR1cm4gJHJlc291cmNlKGFwaUJhc2VVcmwgKyAnL2FwaS91dGlsaXNhdGV1cnMvOmlkJyk7XG4gICAgfVxuICAgIEF4YVNhZmVTZXJ2aWNlcy5Vc2VyU2VydmljZSA9IFVzZXJTZXJ2aWNlO1xufSkoQXhhU2FmZVNlcnZpY2VzIHx8IChBeGFTYWZlU2VydmljZXMgPSB7fSkpO1xuIl0sInNvdXJjZVJvb3QiOiIifQ==
