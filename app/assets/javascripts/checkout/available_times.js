window.onload = function start() { 
  // Performs 2 tasks
  //
  // 1. Reselects appt times selected by current user during session (in case of page refresh, going back to this step)
  // 2. Disables reserved times due to existing bookings or tutor's booking buffer

// 1. Reselects appt times selected by current user during session (in case of page refresh, going back to this step)

  if (gon.selected_appt_ids != null){
    var selectedApptIds = gon.selected_appt_ids
    var apptCount = selectedApptIds.length;
    // re-select checkboxes that have already been clicked
    for (var i = 0; i < selectedApptIds.length; i++) {
      var checkbox = document.getElementById(selectedApptIds[i]);
      if(checkbox != null) {
        checkbox.checked = true;
        checkbox.onchange();
      }
    }
  }

// 2. Disables checkboxes of reserved times due to existing bookings or tutor's booking buffer

  var reservedAppts = document.getElementsByClassName('reserved')
  if (reservedAppts.length > 0) {
    for (var i = 0; i < reservedAppts.length; i++) {
      // disable reserved time
      var checkbox = reservedAppts[i];
      checkbox.dataset.reserved = true;
      checkbox.disabled = true;
      // disable time 30 mins before (if it exists)
      var BeforeId = getTimePillBeforeId(checkbox.id);
      var Before = document.getElementById(BeforeId);
      if (Before != null) {
        Before.dataset.reserved = true;
        Before.disabled = true;
      }
      // disable time 30 mins after (if it exists)
      var AfterId = getTimePillAfterId(checkbox.id);
      var After = document.getElementById(AfterId);
      if (After != null) {
        After.dataset.reserved = true;
        After.disabled = true;
      }
    }
  }
}

gon.watch('selected_appt_ids', {interval: 1000}, function(selected_appt_ids) {
  var p = document.getElementById("number-of-appts");
  var apptCount = selected_appt_ids.length;
  if (apptCount > 1) {
    p.innerHTML = apptCount + " Appointments Selected";
  } else if (apptCount == 1) {
    p.innerHTML = "1 Appointment Selected";
  } else {
    p.innerHTML = "No Appointments Selected";
  }
});

function getTimePillBeforeId(selected_id) {
  var split_selected = selected_id.split("-");
  var doy = parseInt(split_selected[0]);
  var hour = parseInt(split_selected[1]);
  var minute = parseInt(split_selected[2]);
  // make adjustments to time to get id of before time pill
  if (minute == '00') {
    hour = hour - 1;
    minute = '30';
  } else { // minute == '30'
    minute = '00';
  }
  // TODO-JT - refactor this and the method below (both are identical in the bottom portion)
  // make sure hour is a two character string
  hour = hour.toString();
  if(hour.length == 1) {
    hour = '0' + hour;
  }
  // make sure doy is a three character string
  doy = doy.toString();
  if(doy.length == 1) {
    doy = '00' + doy;
  } else if (doy.length == 2) {
    doy = '0' + doy;
  }
  var id = doy + '-' + hour + '-' + minute;
  return id;
}

function getTimePillAfterId(selected_id) {
  var split_selected = selected_id.split("-");
  var doy = parseInt(split_selected[0]);
  var hour = parseInt(split_selected[1]);
  var minute = parseInt(split_selected[2]);
  // make adjustments to time to get id of after time pill
  if (minute == '00') {
    minute = '30';
  } else { // minute == '30'
    hour = hour + 1;
    minute = '00'
  }
  // make sure hour is a two character string
  hour = hour.toString();
  if(hour.length == 1) {
    hour = '0' + hour;
  }
  // make sure doy is a three character string
  doy = doy.toString();
  if(doy.length == 1) {
    doy = '00' + doy;
  } else if (doy.length == 2) {
    doy = '0' + doy;
  }
  var id = doy + '-' + hour + '-' + minute;
  return id;
}


function saveApptTime(element) {
  var selected = element.id;
  var apptTimes = element.value;
  var tutorID = gon.tutor_id;

  //adds or removes appt_time based on selection/de-selection, if it's being added also launches modal prompting regular sessions
  if(element.checked) {
    if (gon.selected_appt_ids == null){
      // if no previously selected times, open modal
      $('#regularApptTimesModal').foundation('reveal', 'open', {
        url: '/tutors/' + tutorID + '/regular_times/',
        data: {appt_info: element.value},
      });
    // if previously selected times exist, check if the appt_time of current element is already saved to the cart
    // only open the modal if the selected time is not already in cart 
    // (because times already in cart were selected earlier and are just being selected on page reload)
    } else { 
      appt_exists = ($.inArray(element.id, gon.selected_appt_ids));
      if (appt_exists == -1){
        $('#regularApptTimesModal').foundation('reveal', 'open', {
          url: '/tutors/' + tutorID + '/regular_times/',
          data: {appt_info: element.value},
        });
      }
    }
    $.post('appt_time', {checkbox_id: selected, appt_times: apptTimes, checkbox: 'selected'});
  }
  else {
    $.post('appt_time', {checkbox_id: selected, appt_times: apptTimes, checkbox: 'deselected'});  
  }
  markTimePills(element);
}

function markTimePills(element) {
  var selected = element.id;

  // get ID of all four relevant checkboxes
  var BeforeId = getTimePillBeforeId(selected)
  var TwoBeforeId = getTimePillBeforeId(BeforeId);
  var AfterId = getTimePillAfterId(selected);
  var TwoAfterId = getTimePillAfterId(AfterId);

  // get relevant checkbox elements with IDs from above
  var Before = document.getElementById(BeforeId);
  var TwoBefore = document.getElementById(TwoBeforeId);
  var After = document.getElementById(AfterId);
  var TwoAfter = document.getElementById(TwoAfterId);

  if (element.checked) { // When a time is SELECTED
    if (Before != null) {
      Before.disabled = true;
    }
    if (After != null) {
      After.disabled = true;
      After.classList.add("second-half-of-appt");
    }
  } else { // When a time is DE-SELECTED
    // Before is the time pill immediately (i.e. 30 mins.) before...
    if ((Before != null) && (Before.dataset.reserved != 'true')) {
      if (TwoBefore == null) { // if TwoBefore does not exist, should turn from gray to empty (take away disabled)
        Before.disabled = false;
      } else if (TwoBefore.checked == true) { // if 2before is selected, should do nothing (stay green and disabled)
        // do nothing
      } else {
        Before.disabled = false;
      }
    }
    // After is the time pill immediately (i.e. 30 mins.) after...
    if (After != null) {
      if (After.dataset.reserved != 'true') {
        if(TwoAfter == null) { // if TwoAfter does not exist, should turn from green to empty (take away disabled & second-half of appt)
          After.disabled = false;
          After.classList.remove('second-half-of-appt');
        } else if (TwoAfter.checked == true) { // if TwoAfter is selected, should turn from green to gray
          After.disabled = true;
          After.classList.remove('second-half-of-appt')
        } else { // if TwoAfter is not selected, should change from green to empty
          After.disabled = false;
          After.classList.remove('second-half-of-appt');
        }
      } else { // if After is reserved, but not selected
        After.disabled = true;
        After.classList.remove('second-half-of-appt');
      }
    }
  }
}