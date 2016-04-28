'use strict';

angular.module('FitBoard')
  .directive('authApplication', function() {
    return {
      restrict: 'C',
      link: function(scope, elem) {
        var login = elem.find('#login-holder');
        var main = elem.find('#content');
        
        //once Angular is started, remove class:
        elem.removeClass('waiting-for-angular');

        login.hide();
        
        scope.$on('event:auth-loginRequired', function() {
          login.slideDown(0, function() {
            main.hide();
          });
        });
        scope.$on('event:auth-forbidden', function() {
          login.slideDown(0, function() {
            main.hide();
          });
        });
        scope.$on('event:auth-loginConfirmed', function() {
          login.slideUp(0, function(){
            main.show();
          });
        });
      }
    };
  });
