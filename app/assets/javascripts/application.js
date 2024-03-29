// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery-ui
//= require jquery-ujs
//= require moment
//= require fullcalendar
//= require chained/jquery.chained.remote.min
//= require Jcrop/js/Jcrop.min
//= require qTip2/jquery.qtip.min.js
//= require sweetalert
//= require moment
//= require moment-range

//= require ./base.js
//= require ./dashboard/courses.js

//= require react
//= require react_ujs
//= require_tree ./react_components
//= require foundation
$(function() {
   $(document).foundation();
 });