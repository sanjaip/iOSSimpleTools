// TheatersController
//
pomidoroApp.controller('TheatersController', function($scope,theatersFactory){

	// This controller is going to set theaters
	// variable for the $scope object in order for view to
	// display its contents on the screen as html
	$scope.theaters = [];

	// Just a housekeeping.
	// In the init method we are declaring all the
	// neccesarry settings and assignments
	init();

	function init(){
		$scope.theaters = theatersFactory.getTheaters();
	}
});

