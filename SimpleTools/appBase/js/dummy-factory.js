// Defining theatersFactory factory
// In this example it has 5 movie theatres
// but in real live application you would
// want it to get this data from the web
// service, based on the the movie selected
// by user
//
pomidoroApp.factory('theatersFactory', function(){
	var theaters = [
		{ name: 'Everyman Walton', address: '85-89 High Street London'},
		{ name: 'Ambassador Cinemas', address: 'Peacocks Centre Woking'},
		{ name: 'ODEON Kingston', address: 'larence Street Kingston Upon Thames'},
		{ name: 'Curzon Richmond', address: '3 Water Lane Richmond'},
		{ name: 'ODEON Studio Richmond', address: '6 Red Lion Street Richmond'}
	];

	var factory = {};
	factory.getTheaters = function(){

		// If performing http communication to receive
		// factory data, the best would be to put http
		// communication code here and return the results
		return theaters;
	}

	return factory;
});