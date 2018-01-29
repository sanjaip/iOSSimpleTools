simpeTools.controller('RootController', function($scope,$window,naitveService){
	$scope.recommendedMovies = [];
    $scope.STdata = [];
    $scope.STdataCnt = 1;
    $scope.STdataStr = "";
    $scope.STdatum = [];
    $scope.started = false;
    console.log( $scope.started);
	init();
    // $scope.saiBaba = function(){alert(); };
    //$scope.collectResponseBits=function(txt){
   //     $scope.STdataStr  = $scope.STdataStr + txt;
   // };
    //$window.collectResponseBits = $scope.collectResponseBits;
	function init(){
     $scope.started = true;
                      naitveService.CallNative("RSM","getRSMJson","","");

    }
                      $window.getRSMJson = function(param){
                     
                      console.log(param);
                      $scope.STdata = param;
                      $scope.currSTKey = 0;
                      $scope.STdatum = param[$scope.currSTKey];
                      $scope.$apply();
                      }

     $scope.step2 = function() {

            if (typeof Android !== "undefined" && Android !== null) {
             Android.runAndroidMethod("step2", "", "");

            } else {
                alert("Not viewing in webview");
            }
        }
     $scope.next = function() {
        $scope.currSTKey = $scope.currSTKey + 1;
        if($scope.currSTKey < $scope.STdata.length)
        {
                      $scope.STdatum= $scope.STdata[$scope.currSTKey];
         //getDetail($scope.STdata[$scope.currSTKey]);
        }
     }
      $scope.prev = function() {
             $scope.currSTKey = $scope.currSTKey - 1 ;
             if($scope.currSTKey > -1)
             {
                         $scope.STdatum= $scope.STdata[$scope.currSTKey];
                 //getDetail($scope.STdata[$scope.currSTKey]);
             }
          }
    function getDetail(mpcode) {
        if (typeof Android !== "undefined" && Android !== null) {
            var str = Android.runAndroidMethod("step5", "", mpcode);
            console.log("result of " +mpcode+ " is " + str);
            $scope.STdatum = JSON.parse(str);
            console.log($scope.STdatum);
        } else {
            alert("Not viewing in webview");
        }

    }
});
