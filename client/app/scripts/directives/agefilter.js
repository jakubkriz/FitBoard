angular.module('FitBoard').filter('ageFilter', function () {
	'use strict';
    function calculateAge (birthday) { // birthday is a date
        var date = new Date(birthday);
        var ageDifMs = Date.now() - date.getTime();
        var ageDate = new Date(ageDifMs); // miliseconds from epoch
        return Math.abs(ageDate.getUTCFullYear() - 1970);
    }

    return function (birthdate) {
        return calculateAge(birthdate);
    };
});