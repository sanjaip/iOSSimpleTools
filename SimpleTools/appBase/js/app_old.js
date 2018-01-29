var complete_JSON = "";

function getResultsNow() {
    alert(complete_JSON);
     var elem = document.getElementById('para');
    document.getElementById("outputjson").innerHTML = complete_JSON;
}

function collectResponseBits(responseBit)
{
    complete_JSON = complete_JSON + responseBit;
}

var myApp = angular.module('RSMApp',[]);

myApp.controller('RSMController', ['$scope', function($scope) {
  $scope.greeting = 'Hola!';
}]);