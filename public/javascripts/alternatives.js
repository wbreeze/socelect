// set buttons when document ready
$(function()
{
  var altsContainer = $('#alternatives');
  //function() {
    var alts = altsContainer.find('.alternative')
    var ctAlt = alts.length;
    if (2 === ctAlt)
    {
       alts.find('input[type="button"]').hide();
    }
  //}();
  jQuery.extend(altsContainer[0], {
    addAlternative : function(el)
    {
      altsContainer.append(el);
      altsContainer.find('input[type="button"]').show();
    },
    checkRemoveAlternative : function(btn)
    {
      var alt = $(btn).closest('.alternative'); 
      var sibAlts = alt.siblings('.alternative')
      var ctAlt = sibAlts.length + 1;
      if (2 < ctAlt) 
      {
        alt.remove()
      } 
      if (3 === ctAlt)
      { 
        sibAlts.find('input[type="button"]').hide();
      }
    }
  });
});
