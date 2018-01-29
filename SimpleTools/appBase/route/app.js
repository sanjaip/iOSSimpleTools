/*
var complete_JSON = "";
var hasValue = false;
function collectResponseBits(responseBit, isNew)
{
    if(isNew)
    {
        complete_JSON = "";
        hasValue = false;
    }
    // Check browser support
    if (typeof(Storage) !== "undefined") {
        // Store
        if(hasValue = true){
            complete_JSON = complete_JSON + localStorage.getItem("STRes");
        }
        localStorage.setItem("STRes", complete_JSON);
        alert(complete_JSON);
        hasValue = true;
    } else {
        //document.getElementById("STLocalStorageError").innerHTML = "Sorry, your phone does not support Web Storage...";
        //document.getElementById("angAppContent").style.display = "none";
    }
}*/
var simpeTools = angular.module('simpeTools',[]);

simpeTools.config(function ($routeProvider) {
	$routeProvider
		.when('/',
		{
			controller: 'TOCController',
			templateUrl: 'views/TOCControllerView.html'
		})
		.when('/rsm',
        {
            controller: 'RootController',
            templateUrl: 'views/RootControllerView.html'
        })
        .when('/AboutUs',
        {
            controller: 'AboutCtrl',
            templateUrl: 'views/AboutUs.html'
        })
        .otherwise({ redirectTo: '/'});
});

simpeTools.config(function ($httpProvider){
    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
});












