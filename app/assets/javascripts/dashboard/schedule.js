$(document).ready(function() {

  $(".fi-widget").unbind().on("click", function(){
    $("#repeating-options").slideToggle(200);
    $(".regular-availability").toggleClass("expanded");
  })

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

  // Setup sweetalert
  swal.setDefaults({
    animation: false
  });

  var tutor_id = $('#axoncalendar').data('tutor');
  var originalStartTime;
  var originalDuration;

  var formatDataAsEvent = function(eventData) {
    end_time = moment(eventData.start_time, moment.ISO_8601);
    end_time = end_time.add(eventData.duration, 'seconds');
    var postFormat = {
      title: "Availability",
      start: moment(eventData.start_time, moment.ISO_8601),
      end: end_time,
      slot_id: eventData.id,
      status: eventData.status === 1 ? 'Blocked' : 'Open'//eventData.status
    };
    return postFormat;
  }

  var eventSource = {
    url: API.endpoints.tutor_slots.get({
      tutor_id: tutor_id
    }),
    eventDataTransform: formatDataAsEvent,
  }

  var beginSlotUpdate = function(event, jsEvent, ui, view) {
    originalStartTime = event.start.toISOString();
    originalDuration = moment.duration(event.end.diff(event.start)).asSeconds();
    tooltip.hide();
  }

  var updateSlotDurationDrop = function(event, delta, revertFunc, jsEvent, ui, view) {
    swal({
        title: "Update all future availability?",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        closeOnConfirm: false,
        closeOnCancel: false,
      },
      function(isConfirm) {
        if (isConfirm) {
          $.ajax({
            type: "POST",
            url: API.endpoints.tutor_slots.update_slot_group({
              tutor_id: tutor_id
            }),
            data: {
              original_start_time: originalStartTime,
              original_duration: originalDuration,
              new_start_time: event.start.toISOString(),
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
        } else {
          $.ajax({
            type: "PUT",
            url: API.endpoints.tutor_slots.update({
              tutor_id: tutor_id,
              slot_id: event.slot_id
            }),
            data: {
              start_time: event.start.toISOString(),
              duration: originalDuration
            },
            dataType: "json",
            success: function(data) {
              $('#calendar').fullCalendar('updateEvent', event);
            },
            error: function(data, status) {
              console.log("failure,", data, status);
              alert('failure', data, status);
              revertFunc();
            }
          });
        }
        swal.close();
      });
  }

  var updateSlotDurationResize = function(event, delta, revertFunc, jsEvent, ui, view) {
    var newDuration = originalDuration + delta.asSeconds();
    if (newDuration < 3600){
      revertFunc();
      return;
    } 

    swal({
        title: "Update all future availability?",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        closeOnConfirm: false,
        closeOnCancel: false
      },
      function(isConfirm) {
        if (isConfirm) {
          $.ajax({
            type: "POST",
            url: API.endpoints.tutor_slots.update_slot_group({
              tutor_id: tutor_id
            }),
            data: {
              original_start_time: originalStartTime,
              original_duration: originalDuration,
              new_start_time: event.start.toISOString(),
              new_duration: newDuration
            },
            dataType: "json",
            success: function(data) {
              console.log("Updated Slots",data);
              $('#calendar').fullCalendar('updateEvent', event);
            },
            error: function(data, status) {
              alert('failure', data, status);
              revertFunc();
            }
          });
        } else {
          $.ajax({
            type: "PUT",
            url: API.endpoints.tutor_slots.update({
              tutor_id: tutor_id,
              slot_id: event.slot_id
            }),
            data: {
              start_time: event.start.toISOString(),
              duration: newDuration
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
        swal.close();
      });
  }

  var addSlot = function(event, jsEvent, ui) {
    //event.start = moment(event.start);
    event.end = moment(event.end);
    var duration = moment.duration(event.end.diff(event.start));
    var seconds = duration.asSeconds();
    var endpoint = API.endpoints.tutor_slots.create({
      tutor_id: tutor_id
    });

    // console.log("START",event.start);
    request = $.post(endpoint, { //DateTime.iso8601('2001-02-03T04:05:06+07:00')
      start_time: event.start.toISOString(), //end_time.add(eventData.duration, 'seconds');
      duration: seconds,
      weeks_to_repeat: event.weeksToRepeat(),
    })

    request.success(function(data) {
      // console.log("DATAADDED", data);
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
      },
      function(isConfirm) {
        isConfirm ? removeSlots(event) : swal.close();
      });
  }

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
        console.log(data);

        $('#calendar').fullCalendar('removeEvents', function(event) {
          console.log("EVENT", event);
          var target = formatDataAsEvent(data[0]);
          console.log("TARGET",target);
          var isStartMatch = (event.start.format('DD HH:mm:ss') === target.start.format('DD HH:mm:ss'));
          var isEndMatch = (event.end.format('DD HH:mm:ss') === target.end.format('DD HH:mm:ss'));
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
    var toggledStatus = event.data.status === 'Open' ? 'Blocked' : 'Open';
    console.log("NEW STATUS",toggledStatus);

    $.ajax({
      type: "PUT",
      url: API.endpoints.tutor_slots.update({
        tutor_id: tutor_id,
        slot_id: event.data.slot_id
      }),
      data: {
        status: toggledStatus //Blocked TODO: make an enumeration in js for this?
      },
      dataType: "json",
      success: function(data) {
        console.log("UPDATE EEVNT");
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
    console.log("STATUS",event.status);
    switch (event.status) {
      case "Open":
        element.css('background-color', '#009688');
        break;
      case "Blocked":
        element.css('background-color', '#E0E0E0');
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
      title: $.trim("Weekly"), // use the element's text as the event title
      overlap: false,
      stick: false, // maintain when user navigates (see docs on the renderEvent method)
      weeksToRepeat: function(){
        if ($.isNumeric($("#weeksToRepeat").val())){
          weeks = $("#weeksToRepeat").val()
        } else {
          weeks = 2
        }
        return weeks
      }
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
      title: $.trim("One Time"), // use the element's text as the event title
      overlap: false,
      stick: false,
      weeksToRepeat: function(){
        return 1
      } // maintain when user navigates (see docs on the renderEvent method)
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