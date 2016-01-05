$(document).ready(function() {

  $(".fi-widget").unbind().on("click", function(){
    $("#repeating-options").slideToggle(200);
    $(".regular-availability").toggleClass("expanded");
  })

  var tutor_id = $('#axoncalendar').data('tutor');
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
   * Does a batch update on slots, this is used for weekly slots. The original start time and
   * duration are necessary for looking up the slots in the backend. 
   */
  var multiSlotUpdate = function(originalStartTime, originalDuration, newStartTime, newDuration) {
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
        $('#calendar').fullCalendar('updateEvent', event);
      },
      error: function(data, status) {
        alert('failure', data, status);
        revertFunc();
      }
    });
  }

  /*
   * Similar to multi, but this uses a  slot id to lookup the slot as opposed to 
   * a range of time.
   */
  var singleSlotUpdate = function(slotID, newStartTime, originalDuration){
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
        $('#calendar').fullCalendar('updateEvent', event);
      },
      error: function(data, status) {
        alert('failure', data, status);
        revertFunc();
      }
    });
  }

  /*
   * When we receive the data from the backend we want to make sure that
   * all the times are formatted correctly. The times come in as 0 offset
   * UTC strings and are converted to moment objects with is8601 format
   * the other data is added to the event object
   */
  var formatDataAsEvent = function(eventData) {
    end_time = moment(eventData.start_time, moment.ISO_8601);
    end_time = end_time.add(eventData.duration, 'seconds');
    var postFormat = {
      title: eventData.slot_type === 0 ? 'Weekly' : 'One Time',
      start: moment(eventData.start_time, moment.ISO_8601),
      end: end_time,
      slot_id: eventData.id,
      status: eventData.status === 0 ? 'Open' : 'Blocked',//eventData.status
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
   * These are events that need to happen before an update to slots
   * we need to preserve the original start time and duration for looking
   * up ranges of time.
   */
  var beginSlotUpdate = function(event, jsEvent, ui, view) {
    originalStartTime = event.start.toISOString();
    originalDuration = moment.duration(event.end.diff(event.start)).asSeconds();
    tooltip.hide();
  }

  /*
   * This is the update function used for when a slot is moved on the  
   * calendar. 
   */
  var updateDrop = function(event, delta, revertFunc, jsEvent, ui, view) {
    if (event.slot_type === "OneTime") {
      singleSlotUpdate(event.slot_id, event.start.toISOString(), originalDuration);
    } else {
      multiSlotUpdate(originalStartTime, originalDuration, event.start.toISOString(), originalDuration);
    }
  }

  /*
   * This is the update function used for when a slot is resized on the  
   * calendar. Enforces a min duration of one hour
   */
  var updateResize = function(event, delta, revertFunc, jsEvent, ui, view) {
    var newDuration = originalDuration + delta.asSeconds();
    
    if (newDuration < 3600){
      revertFunc();
      return;
    } 

    if (event.slot_type === "OneTime") {
      singleSlotUpdate(event.slot_id, event.start.toISOString(), originalDuration);
    } else {
      multiSlotUpdate(originalStartTime, originalDuration, event.start.toISOString(), newDuration);
    }
  }

  /*
   * Attempts to add new slot(s) using the slot_creator service(endpoint) 
   * if successful the ui is updated to show the new slots (called events by fullcalendar)
   */
  var addSlot = function(event, jsEvent, ui) {
    event.end = moment(event.end);
    var duration = moment.duration(event.end.diff(event.start));
    var seconds = duration.asSeconds();
    var endpoint = API.endpoints.tutor_slots.create({
      tutor_id: tutor_id
    });

    request = $.post(endpoint, { 
      start_time: event.start.toISOString(),
      duration: seconds,
      weeks_to_repeat: event.weeksToRepeat(),
      slot_type: event.slot_type,
    })

    request.success(function(data) {
      event.slot_id = data[0].id;
      event.status = data[0].status;
      $('#calendar').fullCalendar('updateEvent', event);
    });

    request.error(function(data) {
      alert("Error!");
    })
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
    $.ajax({
      type: "POST",
      url: API.endpoints.tutor_slots.destroy_slot_group({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: event.data.start.toISOString(),
        original_duration: duration
      },
      dataType: "json",
      success: function(data) {
        $('#calendar').fullCalendar('removeEvents', function(event) {
          var target = formatDataAsEvent(data[0]);
          var isStartMatch = (event.start.format('E HH:mm:ss') === target.start.format('E HH:mm:ss'));
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
        $('#calendar').fullCalendar('updateEvent', event.data);
      },
      error: function(data, status) {
        alert('failure', data, status);
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
    timezone: 'local',
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