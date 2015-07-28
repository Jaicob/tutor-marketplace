$(document).ready(function() {
  // Setup up qTip2 api for
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
  var tutor_id = $('#axoncalendar').data('tutor');
  var originalStartTime;
  var originalDuration;
  var formatDataAsEvent = function(eventData) {
    end_time = moment(eventData.start_time);
    end_time = end_time + moment.duration(eventData.duration, 'seconds');
    return {
      title: "Availability",
      start: eventData.start_time,
      end: end_time,
      slot_id: eventData.id,
      status: eventData.status
    }
  }
  var eventSource = {
    url: API.endpoints.tutor_slots.get({
      tutor_id: tutor_id
    }),
    eventDataTransform: formatDataAsEvent,
  }

  var beginSlotUpdate = function(event, jsEvent, ui, view) {
    originalStartTime = event.start.format('YYYY-MM-DD HH:mm:ss');
    originalDuration = moment.duration(event.end.diff(event.start)).asSeconds();
    tooltip.hide();
  }

  var updateSlotDurationDrop = function(event, delta, revertFunc, jsEvent, ui, view) {
    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: originalStartTime,
        original_duration: originalDuration,
        new_start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
        new_duration: originalDuration
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

  var updateSlotDurationResize = function(event, delta, revertFunc, jsEvent, ui, view) {
    var newDuration = originalDuration + delta.asSeconds();
    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: originalStartTime,
        original_duration: originalDuration,
        new_start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
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

  var addSlot = function(event, jsEvent, ui) {
    var duration = moment.duration(event.end.diff(event.start));
    var seconds = duration.asSeconds();
    var endpoint = API.endpoints.tutor_slots.create({
      tutor_id: tutor_id
    });
    request = $.post(endpoint, {
      start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
      duration: seconds,
      weeks_to_repeat: event.weeksToRepeat,
    })
    request.success(function(data) {
      console.log("DATA", data);
      event.slot_id = data[0].id;
      event.status = data[0].status;
      $('#calendar').fullCalendar('updateEvent', event);
    });
    request.error(function(data) {
      alert("Error!");
    })
  }

  var routeEvent = function(event) {
    tooltip.hide();
    $('div').off('click', '.cal-menu-item');
    var action = event.currentTarget.id;
    switch (action) {
      case 'btn-show-slot':
        showDetails(event);
        break;
      case 'btn-rm-slots':
        askToRemoveSlots(event);
        break;
      case 'btn-block-slot':
        blockSlot(event);
        break;
      default:
        swal('Invalid Selection', 'error')
    }
  }

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
    }, function(isConfirm) {
      isConfirm ? removeSlots(event) : swal("Cancelled");
    });
  }

  var removeSlots = function(callingEvent) {
    var duration = moment.duration(callingEvent.data.end.diff(callingEvent.data.start)).asSeconds();
    $.ajax({
      type: "DELETE",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id
      }),
      data: {
        original_start_time: callingEvent.data.start.format('YYYY-MM-DD HH:mm:ss'),
        original_duration: duration,
        new_start_time: callingEvent.data.start.format('YYYY-MM-DD HH:mm:ss'),
        new_duration: 1
      },
      dataType: "json",
      success: function(data) {
        $('#calendar').fullCalendar('removeEvents', function(event) {
          var isStartMatch = (event.start.format('DD HH:mm:ss') === callingEvent.data.start.format('DD HH:mm:ss'));
          var isEndMatch = (event.end.format('DD HH:mm:ss') === callingEvent.data.end.format('DD HH:mm:ss'));
          return (isStartMatch && isEndMatch) ? true : false;
        });
      },
      error: function(data, status) {
        swal('failure');
        console.log(data, status);
      }
    });
    swal.close();
  }

  var showDetails = function(event) {
    swal({
      title: "Details",
      text: "Start: " + event.data.start.format('dddd HH:mm:ss') + "<br> End: " + event.data.end.format('dddd HH:mm:ss'),
      html: true
    });
  }

  var blockSlot = function(event) {
    var one = $(event.data.currentTarget).status;
    var two = $(event.currentTarget).status;
    var three = $(event.data); //winner
    var four = $(event.data).status;
    console.log("Attempts","1", one, "2", two, "3", three, "four", four);
    var toggledStatus = event.data.status === 'Open' ? 1 : 0;
    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id
      }) + '/' + event.data.slot_id,
      data: {
        status: toggledStatus //Blocked TODO: make an enumeration in js for this?
      },
      dataType: "json",
      success: function(data) {
        console.log("Success",data.status);
        event.data.status = data.status;
        $('#calendar').fullCalendar('updateEvent', event.data);
      },
      error: function(data, status) {
        console.log("failure,", data, status);
        alert('failure', data, status);
      }
    });
  }

  var eventRender = function(event, element, view) {
    switch (event.status) {
      case "Open":
        console.log('non-blocked');
        element.css('background-color', '#3a87ad');
        break;
      case "Blocked":
        console.log('blocked');
        element.css('background-color', 'lightgrey');
        break;
    }
  }

  var setBlockUi = function(event) {
      if (event.status === 'Blocked') {
        $('#block-icon').addClass('fi-unlock').removeClass('fi-lock');
        $('#block-icon').next().text('Unblock');
      } else {
        $('#block-icon').addClass('fi-lock').removeClass('fi-unlock');
        $('#block-icon').next().text('Block');
      }
  }

  var openEventEdit = function(event, jsEvent, view) {
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
      title: $.trim($(this).text()), // use the element's text as the event title
      overlap: false,
      stick: false, // maintain when user navigates (see docs on the renderEvent method)
      weeksToRepeat: 2 //$("#weeksToRepeat").val() TODO add ui from aj
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
      title: $.trim($(this).text()), // use the element's text as the event title
      overlap: false,
      stick: false,
      weeksToRepeat: 1 // maintain when user navigates (see docs on the renderEvent method)
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
  $('#calendar').fullCalendar({
    eventSources: [eventSource],
    slotEventOverlap: false,
    allDaySlot: false,
    forceEventDuration: true,
    minTime: "0:00:00",
    maxTime: "24:00:00",
    defaultTimedEventDuration: "1:00:00",
    height: "auto",
    businessHours: {
      start: '10:00', // a start time (10am in this example)
      end: '10:00', // an end time (6pm in this example)
      dow: [0, 1, 2, 3, 4, 5, 6] // days of week. an array of zero-based day of week integers (0=Sunday)
    },
    header: {
      left: 'prev,next today',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek',
    editable: true,
    droppable: true,
    eventReceive: addSlot,
    eventResizeStart: beginSlotUpdate,
    eventResize: updateSlotDurationResize,
    eventDragStart: beginSlotUpdate,
    eventDrop: updateSlotDurationDrop,
    eventClick: openEventEdit,
    eventRender: eventRender,
    dayClick: function() {
      tooltip.hide()
    },
    viewDisplay: function() {
      tooltip.hide()
    },
  });
});