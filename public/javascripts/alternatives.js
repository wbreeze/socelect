// set buttons when document ready
$(function()
{
  var altsContainer = $('#alternatives');
  jQuery.extend(altsContainer[0], {
    addAlternative: function(el)
    {
      altsContainer.append(el);
      altsContainer.find('input[type="button"]').show();
      altsContainer.find('.alternative:last input[type="text"]:first').focus();
      altsContainer[0].renumberTabNavigation();
    },
    checkRemoveAlternative: function(btn)
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
    },
    initializeRemoveButtons: function() {
      var alts = altsContainer.find('.alternative')
      var ctAlt = alts.length;
      if (2 === ctAlt)
      {
         alts.find('input[type="button"]').hide();
      }
    },
    renumberTabNavigation: function()
    {
      var ti = 1;
      $form = altsContainer.closest('form');
      $form.find('input[type="text"],textarea').each(
        function(index)
        {
          $(this).attr('tabIndex', ti++);
          $(this).attr('tabindex', ti++);
        }
      );
      var addAltTi = ti++;
      $form.find('input[type="button"][type="submit"]').each(
        function(index)
        {
          $(this).attr('tabIndex', ti++);
          $(this).attr('tabindex', ti++);
        }
      );
      $form.find('#addAlternative').attr('tabIndex', addAltTi).attr('tabIndex', addAltTi);
    }
  });
  altsContainer[0].initializeRemoveButtons();
  altsContainer[0].renumberTabNavigation();
  altsContainer.find('.alternative:first input[type="text"]:first').focus();
});