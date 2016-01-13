$(document).ready(function() {
  var tutor_id = $('#axoncalendar').data('tutor');
  var utc_offset = $('#axoncalendar').data('utcoffset');
  var originalStartTime;
  var originalDuration;
  // Configure Qtip
  var tooltip = $('#calendar').qtip({
    id: 'fullcalendar',
    prerender: false,
    content: {
      text: ' ',
      title: {
        button: true
      }
    },
    position: {
      my: 'center left',
      at: 'center right',
      target: 'mouse',
      effect: false,
    },
    effect: false,
    solo: true,
    show: false,
    hide: false,
    style: {
      classes: 'qtip-dark',
    },
  }).qtip('api');
  // Configure sweetalert
  swal.setDefaults({
    animation: false
  });
  /*
   * Responds to events starting and finishing loading 
   */
   var loading = function( isLoading, view ) {
    if (isLoading) {
     $('#calendar').fadeTo(0.6);
     $('#cal-loading').show();
    } else {
      $('#cal-loading').hide();
      $('#calendar').fadeTo(1);
    }
   }
  /*
   * When we receive the data from the backend we want to make sure that
   * all the times are formatted correctly. The times come in as 0 offset
   * UTC strings and are converted to moment objects with is8601 format
   * the other data is added to the event object
   */
  var formatDataAsEvent = function(eventData) {
    var start_time = moment(eventData.start_time).utcOffset(utc_offset);
    var end_time = start_time.clone().add(eventData.duration, 'seconds');
    var e_status = eventData.status === 0 ? 'Open' : 'Blocked';
    var e_title = eventData.slot_type === 0 ? 'Weekly' : 'OneTime';
    if ( e_status === 'Blocked' ) {
      e_title = 'Blocked';
    }
    var postFormat = {
      title: e_title,
      start: start_time,
      end: end_time,
      protected_start: start_time.clone(),
      protected_end: end_time.clone(),
      slot_id: eventData.id,
      status: e_status,
      slot_type: eventData.slot_type === 0 ? 'Weekly' : 'OneTime'
    };
    return postFormat;
  }
  /*
   * Defines a source for which event data is coming from and applies 
   * the transform to format the incoming data correctly
   */
  var eventSource = {
    url: API.endpoints.tutor_slots.get({
      tutor_id: tutor_id
    }),
    eventDataTransform: formatDataAsEvent,
  }
  /*
   * This is the update function used for when a slot is moved on the  
   * calendar. 
   */
  var updateDrop = function(event, delta, revertFunc, jsEvent, ui, view) {
    var newStartTime = event.start.hasZone() ? event.start.clone() : event.protected_start.clone();
    newStartTime.date(event.start.date());
    newStartTime.hour(event.start.hour());
    newStartTime.minute(event.start.minute());
    newStartTime = newStartTime.toISOString();
    if (event.slot_type === "OneTime") {
      singleSlotUpdate(event, event.slot_id, newStartTime, originalDuration);
    } else {
      multiSlotUpdate(event, originalStartTime, originalDuration, newStartTime, originalDuration);
    }
  }
  /*
   * This is the update function used for when a slot is resized on the  
   * calendar. Enforces a min duration of one hour
   */
  var updateResize = function(event, delta, revertFunc, jsEvent, ui, view) {
    var newDuration = originalDuration + delta.asSeconds();
    var newStartTime = event.start.hasZone() ? event.start.clone() : event.protected_start.clone();
    newStartTime.date(event.start.date());
    newStartTime = newStartTime.toISOString();
    
    if (newDuration < 3600){
      revertFunc();
      return;
    } 
    if (event.slot_type === "OneTime") {
      singleSlotUpdate(event, event.slot_id, newStartTime, newDuration);//IsoString has no offset, format does
    } else {
      multiSlotUpdate(event, originalStartTime, originalDuration, newStartTime, newDuration);
    }
  }
  /*
   * These are events that need to happen before an update to slots
   * we need to preserve the original start time and duration for looking
   * up ranges of time.
   */
  var beginSlotUpdate = function(event, jsEvent, ui, view) {
    var og = event.start.hasZone() ? event.start.clone() : event.protected_start.clone();
    originalStartTime = og.toISOString();
    originalDuration  = moment.duration(event.end.diff(event.start)).asSeconds();
    tooltip.hide();
  }
  /*
   * Does a batch update on slots, this is used for weekly slots. The original start time and
   * duration are necessary for looking up the slots in the backend. 
   */
  var multiSlotUpdate = function(event, originalStartTime, originalDuration, newStartTime, newDuration) {
    $.ajax({
      type: "POST",
      url: API.endpoints.tutor_slots.update_slot_group({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: originalStartTime,
        original_duration: originalDuration,
        new_start_time: newStartTime,
        new_duration: newDuration
      },
      dataType: "json",
      success: function(data) {
        var target = formatDataAsEvent(data[0]);         
        event.protected_start = target.protected_start;
        event.protected_end = target.protected_end;
        $('#calendar').fullCalendar('updateEvent', event);
      },
      error: function(data, status) {
        swal('failure', data, status);
      }
    });
  }
  /*
   * Similar to multi, but this uses a  slot id to lookup the slot as opposed to 
   * a range of time.
   */
  var singleSlotUpdate = function(event, slotID, newStartTime, originalDuration){
    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id,
        slot_id: slotID
      }),
      data: {
        start_time: newStartTime,
        duration: originalDuration
      },
      dataType: "json",
      success: function(data) {
        var target = formatDataAsEvent(data);         
        event.protected_start = target.protected_start;
        event.protected_end = target.protected_end;
        $('#calendar').fullCalendar('updateEvent', event);
      },
      error: function(data, status) {
        swal('failure', data, status);
      }
    });
  }
  /*
   * Attempts to add new slot(s) using the slot_creator service(endpoint) 
   * if successful the ui is updated to show the new slots (called events by fullcalendar)
   */
  var addSlot = function(event, jsEvent, ui) {
    var start_time = event.start.subtract(utc_offset, 'minutes').utcOffset(utc_offset);
    var end_time = event.end.subtract(utc_offset, 'minutes').utcOffset(utc_offset);
    var duration = moment.duration(end_time.diff(start_time));
    var seconds = duration.asSeconds();
    var endpoint = API.endpoints.tutor_slots.create({
      tutor_id: tutor_id
    });
    request = $.post(endpoint, { 
      start_time: event.start.format(),
      duration: seconds,
      weeks_to_repeat: event.weeksToRepeat(),
      slot_type: event.slot_type,
    })
    request.success(function(data) {
      var formattedEvent = formatDataAsEvent(data[0]);
      event.start = formattedEvent.start;
      event.end = formattedEvent.end;
      event.slot_id = formattedEvent.slot_id;
      event.protected_start = formattedEvent.protected_start;
      event.protected_end = formattedEvent.protected_end;
      event.status = 'Open';
      $('#calendar').fullCalendar('updateEvent', event);
    });
    request.error(function(data) {
      swal("Error!");
    })
  }
  /*
   * This function presents a modal that confirms with the user before removing slots
   */
  var askToRemoveSlots = function(event) {
    swal({
        title: "Are you sure?",
        text: "This availability will be permanently deleted",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, remove it!",
        cancelButtonText: "Cancel",
        closeOnConfirm: false,
        closeOnCancel: false
      },
      function(isConfirm) {
        isConfirm ? removeSlots(event) : swal.close();
      });
  }
  /*
   * This method sends a request to remove a batch of slots based off of the start time
   * and duration. If succesful all slots removed are returned and the corresponding fullcalendar
   * events are removed from the view.
   */
  var removeSlots = function(event) {
    var duration = moment.duration(event.data.end.diff(event.data.start)).asSeconds();
    var og = event.data.start.hasZone() ? event.data.start.clone() : event.data.protected_start.clone();
 
    $.ajax({
      type: "POST",
      url: API.endpoints.tutor_slots.destroy_slot_group({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: og.toISOString(),
        original_duration: duration
      },
      dataType: "json",
      success: function(data) {
        $('#calendar').fullCalendar('removeEvents', function(event) {
          var target = formatDataAsEvent(data[0]);
          var isStartMatch = ( event.start.format('E HH:mm:ss') === target.start.format('E HH:mm:ss'));
          var isEndMatch = (event.end.format('E HH:mm:ss') === target.end.format('E HH:mm:ss'));
          return (isStartMatch && isEndMatch) ? true : false;
        });
      },
      error: function(data, status) {
        swal('failure');
      }
    });
    swal.close();
  }
  /*
   * When you click on a slot/event a mini menu pops up this function
   * routes the correct actions based on what you click
   */
  var routeEvent = function(event) {
    tooltip.hide();
    $('div').off('click', '.cal-menu-item');
    var action = event.currentTarget.id;
    switch (action) {
      case 'btn-rm-slots':
        askToRemoveSlots(event);
        break;
      case 'btn-block-slot':
        toggleBlockSlot(event);
        break;
      default:
        swal('Invalid Selection', 'error')
    }
  }
  /*
   * Updates a slots status to be blocked if open, and open if blocked.
   * If successful then the event is updated
   */
  var toggleBlockSlot = function(event) {
    var toggledStatus = event.data.status === 'Open' ? 'Blocked' : 'Open';
    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id,
        slot_id: event.data.slot_id
      }),
      data: {
        status: toggledStatus 
      },
      dataType: "json",
      success: function(data) {
        event.data.status = data.status;
        event.data.title = event.data.status === 'Open' ? event.data.slot_type : 'Blocked';
        $('#calendar').fullCalendar('updateEvent', event.data);
      },
      error: function(data, status) {
        swal('failure', data, status);
      }
    });
  }
  /*
   * Used to determine the appropriate styling of an event based on
   * the status and type
   */
  var eventRender = function(event, element, view) {
    if (event.status === 'Blocked') {
      element.css('background-color', '#E0E0E0');
      event.title = "Blocked";
    } else {
      event.title = event.slot_type;
      switch (event.slot_type) {
        case 'Weekly':
          element.css('background-color', '#009688');
          break;
        case 'OneTime':
          element.css('background-color', '#FF9100');
          break;
      }
    }
  }
  /*
   * toggles the symbol used in the mini-menu to reflect the status of the slot
   */  
  var setBlockUi = function(event) {
    if (event.status === 'Blocked') {
      $('#block-icon').addClass('fi-unlock').removeClass('fi-lock');
      $('#block-icon').next().text('Unblock');
    } else {
      $('#block-icon').addClass('fi-lock').removeClass('fi-unlock');
      $('#block-icon').next().text('Block');
    }
  }
  /*
   * Opens the mini-menu of the event/slot within a tooltip that appears to 
   * the right of the slot.
   */
  var openEventMiniMenu = function(event, jsEvent, view) {
    $('div').off('click', '.cal-menu-item');
    $('div').on('click', '.cal-menu-item', event, routeEvent);
    setBlockUi(event);
    tooltip.set({
      'content.text': $('#calendar').next('div').clone(true),
      'position.target': $(this),
      'show.effect': false,
      'hide.target': $(this),
      'hide.event': false
    }).reposition(event).show(event);
  }
  /*
   * Initialize the external events
   */
  $('.regular-availability').each(function() {
    // store data so the calendar knows to render an event upon drop
    $(this).data('event', {
      title: $.trim("Saving..."), // use the element's text as the event title
      overlap: false,
      stick: false, // maintain when user navigates (see docs on the renderEvent method)
      weeksToRepeat: function(){
        if ($.isNumeric($("#weeksToRepeat").val()) && $("#weeksToRepeat").val() > 1){
          weeks = $("#weeksToRepeat").val();
        } else {
          weeks = 2;
        }
        return weeks;
      },
      slot_type:'Weekly'
    });
    // make the event draggable using jQuery UI
    $(this).draggable({
      zIndex: 999,
      revert: true, // will cause the event to go back to its
      revertDuration: 0 //  original position after the drag
    });
  });
  $('.one-off-availability').each(function() {
    // store data so the calendar knows to render an event upon drop
    $(this).data('event', {
      title: $.trim("Saving..."), // use the element's text as the event title
      overlap: false,
      stick: false,
      weeksToRepeat: function(){
        return 1
      }, // maintain when user navigates (see docs on the renderEvent method)
      slot_type:'OneTime'
    });
    // make the event draggable using jQuery UI
    $(this).draggable({
      zIndex: 999,
      revert: true, // will cause the event to go back to its
      revertDuration: 0 //  original position after the drag
    });
  });
  /*
   * Initialize the calendar
   */
  fcalendar =  $('#calendar').fullCalendar({
    eventSources: [eventSource],
    timezone: false,
    slotEventOverlap: false,
    eventOverlap: function(stillEvent, movingEvent) { return stillEvent.allDay && movingEvent.allDay },
    allDaySlot: false,
    forceEventDuration: true,
    minTime: "6:00:00",
    maxTime: "24:00:00",
    defaultTimedEventDuration: "2:00:00",
    height: "auto",
    header: {
      left: 'prev,next today',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek',
    loading: loading,
    editable: true,
    droppable: true,
    eventReceive: addSlot,
    eventResizeStart: beginSlotUpdate,
    eventResize: updateResize,
    eventDragStart: beginSlotUpdate,
    eventDrop: updateDrop,
    eventClick: openEventMiniMenu,
    eventRender: eventRender,
    dayClick: function() {
      tooltip.hide()
    },
    viewDisplay: function() {
      tooltip.hide()
    },
  });
});