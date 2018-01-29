// SettingsController
//
var myApp = angular.module('myApp', ['naitveService']);
simpeTools.controller('TOCController', function($scope,$window,naitveService) {


  init();

  function init() {
         naitveService.CallNative("RSM","getRSMLocalDBCount","","");
                      
    //check for app readiness

    /*if (typeof Android !== "undefined" && Android !== null) {
      var reccount = Android.runAndroidMethod("readyRSMApp", "", "");
      if(reccount > 0)
      {
       $scope.isTOCAppReady = "true";
      }
      else
      {
       $scope.isTOCAppReady = "false";
      }
    } else {
      alert("Not viewing in webview");
    }*/
  }
  $scope.step1 = function() {
    if (typeof Android !== "undefined" && Android !== null) {
      Android.runAndroidMethod("step1", "", "");
    } else {
      alert("Not viewing in webview");
    }
  }
  $scope.step2 = function() {
    if (typeof Android !== "undefined" && Android !== null) {
      Android.runAndroidMethod("step2", "", "");
    } else {
      alert("Not viewing in webview");
    }
  }
  $scope.step4 = function() {
    if (typeof Android !== "undefined" && Android !== null) {
      Android.runAndroidMethod("step4", "", "2338");
    } else {
      alert("Not viewing in webview");
    }
  }
  $scope.initApp = function(modName) {
                      console.log("calling init "+modName+" app");
                      switch(modName){
                        case 'RSM':
                            naitveService.CallNative("RSM","fillLocalDBFromService","callBack_fillLocalDBFromService","");
                        break;
                      }
    }
$window.callBack_fillLocalDBFromService = function(param){
      /* $scope.JSONUrlFromCoreData = param;param.replace('/', '');var obj = JSON.parse(param);alert(obj);console.log(obj.length);*/
      if(param === "Done")
      {
        $scope.isTOCAppReady = "true";
      }else{
        $scope.isTOCAppReady = "false";
      }
                      $scope.$apply();
    }
                     
                      $window.getRSMLocalDBCount = function(param){
                      var cnt =  parseInt(param);
                      console.log(cnt);
                      $scope.RSMCount = cnt;
                      if(cnt > 0)
                      {
                      $scope.isTOCAppReady = "true";
                      console.log(true);
                      }else{
                      $scope.isTOCAppReady = "false";
                       console.log(false);
                      }
                      $scope.$apply();
                      }
                      
  $scope.readyRSMApp = function() {
    if (typeof Android !== "undefined" && Android !== null) {
      Android.runAndroidMethod("readyRSMApp", "", "");
    } else {
      alert("Not viewing in webview");
    }
  }
});
