angular.module('FitBoard').directive('validPasswordC', function () {
    'use strict';
    return {
        require: 'ngModel',
        link: function (scope, elm, attrs, ctrl) {
            ctrl.$parsers.unshift(function (viewValue, $scope) {
                var noMatch = viewValue !== scope.editPass.password.$viewValue;
                ctrl.$setValidity('noMatch', !noMatch);
            });
        }
    };
});