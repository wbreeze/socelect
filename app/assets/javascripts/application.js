// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery-1.5.2.min.js
//= require jquery-ui-1.8.11.custom.min.js
//= require rails.js
//= require jquery.ptTimeSelect.js
//= require_self
$(document).ready(function() {
  $('input.time_entry').ptTimeSelect();
  $('input.date_entry').datepicker({
    changeMonth: true,
    changeYear: true
  });
});
