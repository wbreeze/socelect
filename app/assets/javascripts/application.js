// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require rails-ujs
//= require jquery-3.4.1
//= require jquery-ui-1.12.1
//= require parceled
//= require_self
$(document).ready(function() {
  $('input.date_entry').datepicker({
    changeMonth: true,
    changeYear: true,
    dateFormat: 'yy-mm-dd'
  });
});
