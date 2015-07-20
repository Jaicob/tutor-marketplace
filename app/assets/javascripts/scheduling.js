$(document).ready(function() {


  var tutor_id = $('#axoncalendar').data('tutor');

  var origninalStartTime;
  var originalEndTime;

  var formatDataAsEvent = function( eventData ) {
    return {
      title:    "Availability",
      start:    eventData.start_time,
      end:      eventData.end_time,
      slot_id:  eventData.id 
    }
  }

  var eventSource = {
    url: '/api/v1/tutors/' + tutor_id + '/slots.json',
    eventDataTransform: formatDataAsEvent,
    color: 'yellow',   // a non-ajax option
    textColor: 'black' // a non-ajax option
  }

  var beginSlotUpdate = function( event, jsEvent, ui, view) { 
    origninalStartTime = event.start.format('YYYY-MM-DD HH:mm:ss');
    originalEndTime = event.end.format('YYYY-MM-DD HH:mm:ss');
  }

  var updateSlotDuration = function( event, jsEvent, ui, view) {
    var jqxhr = $.ajax({
    type: "POST",
    url: '/api/v1/tutors/' + tutor_id + '/slots/all', 
    data: {
      start_time: origninalStartTime,
      end_time: originalEndTime,
      new_start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
      new_end_time: event.end.format('YYYY-MM-DD HH:mm:ss')
    },
    dataType: "json",
    success: function(data){
      alert('success');
      $('#calendar').fullCalendar( 'refetchEvents' )
    },
    error: function(data, status, blah){
      alert('failure',data,status,blah);
      console.log('failure',data,status,blah); 
    }
    });
    console.log("update",event, jsEvent, ui, view)
  }

  var addSlot = function(event, jsEvent, ui ){
    request = $.post('/api/v1/tutors/' + tutor_id + '/slots', {
      start_time : event.start.format('YYYY-MM-DD HH:mm:ss'),
      end_time : event.end.format('YYYY-MM-DD HH:mm:ss'),
      start_date: event.start.format('YYYY-MM-DD HH:mm:ss'),
      end_date: event.start.format('YYYY-MM-DD HH:mm:ss')
    })
    request.success(function(data){
      alert("Success!")
      console.log(data);
    });
    request.error(function(data){
      alert("Error!")
      console.log(data);
    })
  }

  /*
   * Initialize the external events
   */
  $('.fc-event').each(function() {
    // store data so the calendar knows to render an event upon drop
    $(this).data('event', {
      title: $.trim($(this).text()), // use the element's text as the event title
      stick: true // maintain when user navigates (see docs on the renderEvent method)
    });

    // make the event draggable using jQuery UI
    $(this).draggable({
      zIndex: 999,
      revert: true,      // will cause the event to go back to its
      revertDuration: 0  //  original position after the drag
    });
  });

  /* 
   * Initialize the calendar
   */
  $('#calendar').fullCalendar({
    eventSources:[eventSource],
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
        dow: [ 0, 1, 2, 3, 4, 5, 6 ]  // days of week. an array of zero-based day of week integers (0=Sunday)
    },
    header: {
      left: 'prev,next today',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek',
    editable: true,
    droppable: true, 
    eventReceive : addSlot,
    eventResizeStart: beginSlotUpdate,
    eventResize: updateSlotDuration
  });

  });