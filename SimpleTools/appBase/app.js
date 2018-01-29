
/*function callNativeApp() {
    try {
        webkit.messageHandlers.messageBox.postMessage("Send from JavaScript");
    } catch(err) {
        console.log('error');
    }
}
//http://zacklalanne.me/webapp-over-the-file-protocol-using-angularjs/
angular.module('TestApp', ['TestApp.controllers',
                           'TestApp.services',
                           'angularLoad'
                           ]);
angular.module('TestApp.services', []).factory('coreDataAPIservice', function($http) {
                                               var coreDataAPIservice = {};
                                               return coreDataAPIservice;
                                               });
angular.module('TestApp.controllers', ['angularLoad']).controller('TestCtrl', function($scope, $window,coreDataAPIservice,angularLoad) {
    $window.abcd = function(param){
           $scope.JSONUrlFromCoreData = param;
                                                                  //console.log(param);
                                                                  param.replace('/', '');
                                                                  var obj = JSON.parse(param);
                                                                  
                                                                  console.log(obj.length);
    }
   
});*/
