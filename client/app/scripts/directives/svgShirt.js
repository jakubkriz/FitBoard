angular.module('FitBoard').directive('svgShirt', ['$compile', function () {
	'use strict';
    return {
        restrict: 'A',
        templateUrl: 'img/shirt.svg',
        link: function () {
            
        }
    };
}]);