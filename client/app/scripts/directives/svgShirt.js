angular.module('FitBoard').directive('svgShirt', ['$compile', function ($compile) {
	'use strict';
    return {
        restrict: 'A',
        templateUrl: 'img/shirt.svg',
        link: function (scope, element, attrs) {
            
        }
    };
}]);