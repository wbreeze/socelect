// Convert UTC hidden fields to local date and time display and edit
// Convert local date and time edit fields to UTC and write to hidden fields
// Use the jQuery datepicker to select the date
// Use selection scrollers to select any hour, minute, seconds
// Display the local time zone offset correct for the date, adjusted for
// any daylight savings time
// Extends the jQuery object with a function, $.rails_date_time_select()
// The function 'id' parameter is the name of the rails variable that contains 
// the date and time in UTC.
$.extend({rails_date_time_select : function (id) {
  var dateFormat = 'DD, MM d, yy';
  var altFormat = 'D, MM d yy';

  var ofsDisplayID = '#' + id + '_offset_display'; // p, span or div, visible
  var ofsFieldID = '#' + id + '_time_offset'; // hidden form input
  var altFieldID = '#' + id + '_date_alt'; // hidden form input
  var displayFieldID = '#' + id + '_date'; // visible form input

  var yearFieldID = '#' + id + '_1i'; // hidden form input
  var monthFieldID = '#' + id + '_2i'; // hidden form input
  var dayFieldID = '#' + id + '_3i'; // hidden form input
  var hourFieldID = '#' + id + '_4i'; // hidden form input
  var minutesFieldID = '#' + id + '_5i'; // hidden form input
  var secondsFieldID = '#' + id + '_6i'; // hidden form input

  var hourID = '#' + id + '_time_hour'; // visible form input
  var minID = '#' + id + '_time_min'; // visible form input
  var secID = '#' + id + '_time_sec'; // visible form input

  function showTimezoneOffset(dispDate) {
    mOffset = dispDate.getTimezoneOffset();
    // in the hidden input field
    $(ofsFieldID).val(-mOffset);
    // on the display
    hOffset = Math.abs(mOffset / 60);
    hS = 0 < mOffset ? '-' : '';
    hS += hOffset < 10 ? '0' + hOffset : hOffset;
    mOffset %= 60;
    mS = mOffset < 10 ? '0' + mOffset : mOffset;
    $(ofsDisplayID).html('UTC ' + hS + ':' + mS);
  }

  function updateDerivedFields(ev) {
    df = $(altFieldID);
    newDate = new Date(Date.parse(df.val()));
    hf = $(hourID);
    if (0 < hf.length)
    {
      // we have time fields
      hourV = Number(hf.val());
      mf = $(minID);
      minV = (0 < mf.length) ? Number(mf.val()) : 0;
      sf = $(secID);
      secV = (0 < sf.length) ? Number(sf.val()) : 0;
      newDate.setHours(hourV);
      newDate.setMinutes(minV);
      newDate.setSeconds(secV);
      $(hourFieldID).val(newDate.getUTCHours());
      $(minutesFieldID).val(newDate.getUTCMinutes());
      $(secondsFieldID).val(newDate.getUTCSeconds());
    }
    $(monthFieldID).val(newDate.getUTCMonth()+1);
    $(dayFieldID).val(newDate.getUTCDate());
    $(yearFieldID).val(newDate.getUTCFullYear());

    showTimezoneOffset(newDate);
  }

  now = new Date();
  // read current values into displayed values
  yrV = Number($(yearFieldID).val() || now.getUTCFullYear());
  moV = Number($(monthFieldID).val() || now.getUTCMonth()) - 1;
  daV = Number($(dayFieldID).val() || now.getUTCDate());
  hrV = Number($(hourFieldID).val() || now.getUTCHours());
  mnV = Number($(minutesFieldID).val() || now.getUTCMinutes());
  scV = Number($(secondsFieldID).val() || now.getUTCSeconds());
  dispDate = new Date(Date.UTC(yrV, moV, daV, hrV, mnV, scV));

  $(altFieldID).val($.datepicker.formatDate(altFormat, dispDate));
  $(displayFieldID).val($.datepicker.formatDate(dateFormat, dispDate));
  hrV = dispDate.getHours();
  hrS = hrV < 10 ? '0' + hrV : hrV;
  $(hourID).val(hrS);
  mnV = dispDate.getMinutes();
  mnS = mnV < 10 ? '0' + mnV : mnV;
  $(minID).val(mnV);
  scV = dispDate.getSeconds();
  scS = scV < 10 ? '0' + scV : scV;
  $(secID).val(scV);

  showTimezoneOffset(dispDate);

  // set-up date picker and on-change behaviors
  dateField = $(displayFieldID);
  dateField.datepicker({altField: altFieldID, 
    altFormat: altFormat, dateFormat: dateFormat});
  dateField.change(updateDerivedFields);
  $(hourID).change(updateDerivedFields);
  $(minID).change(updateDerivedFields);
  $(secID).change(updateDerivedFields);
}});

