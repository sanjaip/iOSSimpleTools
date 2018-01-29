///////////// FACTORIES ////////////////////////////

// Defining recommendedMovies factory
// It has 5 recomended movies and
// makes them awailable to controller
// so it can pass values to the temmplate
//
simpeTools.factory('recommendedMoviesFactory', function($http){
	var recommended = [
		{ name: 'World War Z', description: 'The story revolves around United Nations employee Gerry Lane (Pitt), who traverses the world in a race against time to stop a pandemic', img: 'img/wardwarz.png'},
		{ name: 'Star Trek Into Darkness', description: 'When the crew of the Enterprise is called back home, they find an unstoppable force of terror from within their own organization has detonated the fleet and everything it stands for', img: 'img/intodarkness.png'},
		{ name: 'The Iceman', description: 'Appearing to be living the American dream as a devoted husband and father in reality Kuklinski was a ruthless killer-for-hire.', img: 'img/wardwarz.png'},
		{ name: 'Iron Man 3', description: 'When Stark finds his personal world destroyed at his enemys hands, he embarks on a harrowing quest to find those responsible.', img: 'img/wardwarz.png'},
		{ name: 'Django Unchained', description: 'Set in the South two years before the Civil War, Django Unchained stars Jamie Foxx as Django', img: 'img/wardwarz.png'}

	];

	var factory = {};
	factory.getRecommended = function(){


		// This is the place for performing http communication
		// with 3rd party web services.
		var url = 'http://your.backend.url'

		return $http.get(url).then( function(response){
			return response.data;
		})

	}

	return factory;
});