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
  url: '/api/v1/tutors/1/slots.json',
  eventDataTransform: formatDataAsEvent,
  color: 'yellow',   // a non-ajax option
  textColor: 'black' // a non-ajax option
}

var droppedEvent = function(date, jsEvent, ui ){
  alert("add",date, jsEvent, ui);
}

var beginSlotUpdate = function( event, jsEvent, ui, view) { 
  origninalStartTime = event.start.toDate();
  originalEndTime = event.end.toDate();
  console.log("DATE",event.end.toDate());
}

var updateSlotDuration = function( event, jsEvent, ui, view) {
  console.log("NEW DATE",event.end.toDate());
  var jqxhr = $.ajax({
  type: "POST",
  url: '/api/v1/tutors/1/slots/all', 
  data: {
    start_time: origninalStartTime,
    end_time: originalEndTime,
    new_start_time: event.start.toDate(),
    new_end_time: event.end.toDate()
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

var addSlot = function(event){
  request = $.post("/api/v1/tutors/" + tutor_id + "/slots", {
    "start_time" : event.start.format("HH:mm"),
    "end_time" : event.start.add(1, "hours").format("HH:mm"),
    "date" : event.start.format("YYYY-MM-DD"),
    "tutor_id" : tutor_id,
  })
  request.success(function(data){
    alert("Success!")
  });
  request.error(function(){
    alert("Error!")
  })
}

$(document).ready(function() {

    /* initialize the external events
    -----------------------------------------------------------------*/
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


    /* initialize the calendar
    -----------------------------------------------------------------*/
    $('#calendar').fullCalendar({
      eventSources:[eventSource], //[{url: '/api/v1/tutors/1/slots.json', eventDataTransform: formatDataAsEvent}],
      slotEventOverlap: false,
      allDaySlot: false,
      minTime: "6:00:00",
      maxTime: "22:00:00",
      defaultTimedEventDuration: "1:00:00",
      height: "auto",
      businessHours: {
          start: '10:00', // a start time (10am in this example)
          end: '10:00', // an end time (6pm in this example)

          dow: [ 0, 1, 2, 3, 4, 5, 6 ]
          // days of week. an array of zero-based day of week integers (0=Sunday)
          // (Monday-Thursday in this example)
      },
      header: {
        left: 'prev,next today',
        right: 'month,agendaWeek,agendaDay'
      },
      defaultView: 'agendaWeek',
      editable: true,
      droppable: true, // this allows things to be dropped onto the calendar
      drop: droppedEvent,
      eventResizeStart: beginSlotUpdate,
      eventResize: updateSlotDuration
    });

  });