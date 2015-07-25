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
    solo:true,
    show: false,
    hide: false,
    style: {
      classes: 'qtip-light',
      height: '250px',
      width: '150px'
    },
  }).qtip('api');

  var tutor_id = $('#axoncalendar').data('tutor');
  var originalStartTime;
  var originalDuration;

  var formatDataAsEvent = function( eventData ) {
    end_time = moment(eventData.start_time);
    end_time = end_time + moment.duration(eventData.duration, 'seconds');
    return {
      title:    "Availability",
      start:    eventData.start_time,
      end:      end_time,
      slot_id:  eventData.id
    }
  }

  var eventSource = {
    url: API.endpoints.tutor_slots.get({ tutor_id: tutor_id }),
    eventDataTransform: formatDataAsEvent,
    color: 'yellow',   // a non-ajax option
    textColor: 'black' // a non-ajax option
  }

  var beginSlotUpdate = function( event, jsEvent, ui, view) {
    originalStartTime = event.start.format('YYYY-MM-DD HH:mm:ss');
    originalDuration = moment.duration(event.end.diff(event.start)).asSeconds();
    tooltip.hide();
  }

  var updateSlotDurationDrop = function( event, delta, revertFunc, jsEvent, ui, view ) {
    var jqxhr = $.ajax({
    type: "PUT",
    url: API.endpoints.tutor_slots.update({tutor_id: tutor_id}),
    data: {
      original_start_time: originalStartTime,
      original_duration: originalDuration,
      new_start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
      new_duration: originalDuration
    },
    dataType: "json",
    success: function(data){
      alert('success');
      $('#calendar').fullCalendar('updateEvent', event);
    },
    error: function(data, status){
      alert('failure',data,status);
      console.log(data, status);
      revertFunc();
      }
    });
  }

  var updateSlotDurationResize = function( event, delta, revertFunc, jsEvent, ui, view ) {
    var newDuration = originalDuration + delta.asSeconds();
    var jqxhr = $.ajax({
    type: "PUT",
    url: API.endpoints.tutor_slots.update({tutor_id: tutor_id}),
    data: {
      original_start_time: originalStartTime,
      original_duration: originalDuration,
      new_start_time: event.start.format('YYYY-MM-DD HH:mm:ss'),
      new_duration: newDuration
    },
    dataType: "json",
    success: function(data){
      alert('success');
      $('#calendar').fullCalendar('updateEvent', event);
    },
    error: function(data, status){
      alert('failure',data,status);
      console.log(data, status);
      revertFunc();
      }
    });
  }

  var addSlot = function(event, jsEvent, ui ){
    var duration = moment.duration(event.end.diff(event.start));
    var seconds = duration.asSeconds();
    console.log("DURATION", seconds);

    var endpoint = API.endpoints.tutor_slots.create({ tutor_id: tutor_id })
    request = $.post(endpoint, {
      start_time : event.start.format('YYYY-MM-DD HH:mm:ss'),
      duration: seconds,
      weeks_to_repeat: 2,
    })
    request.success(function(data){
      alert("Success!")
    });
    request.error(function(data){
      alert("Error!")
    })
  }

  var removeSlots = function (event) {
    swal("removing slot at ", event.data.start.toDate());
    console.log("Called remove slots");
    console.log("REM EVENT",event);
  }

  var AfterAllRender = function( view ) { 
    //$('div').on( 'click', '#btn-rm-slots',  removeSlots);
  }

  var openEventEdit = function( event, jsEvent, view  ) { 
    $('div').off('click', '#btn-rm-slots');
    $('div').on('click', '#btn-rm-slots',  event,removeSlots);
    console.log("EVENT", this);
    tooltip.set({
      'content.text': $('#calendar').next('div').clone(true),//$(this).next('div'),
      'position.target': $(this),
      'show.effect':false,
      'hide.target': $(this),
      'hide.event': false
    }).reposition(event).show(event);
  } 

  var eventRender = function (event, element, view) {
    // Do stuff to event objects as they render. May not need to keep this.
    // var content = $(".slotpopover");
    // element.append(content);
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
      weeksToRepeat: $("#weeksToRepeat").val()
    });

    // make the event draggable using jQuery UI
    $(this).draggable({
      zIndex: 999,
      revert: true,      // will cause the event to go back to its
      revertDuration: 0  //  original position after the drag
    });
  });

  $('.one-off-availability').each(function() {
    // store data so the calendar knows to render an event upon drop
    $(this).data('event', {
      title: $.trim($(this).text()), // use the element's text as the event title
      overlap: false,
      stick: false // maintain when user navigates (see docs on the renderEvent method)
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
    eventResize: updateSlotDurationResize,
    eventDragStart: beginSlotUpdate,
    eventDrop: updateSlotDurationDrop,
    eventClick: openEventEdit,
    eventRender: eventRender, 
    dayClick: function() { tooltip.hide() },
    viewDisplay: function() { tooltip.hide() },
    eventAfterAllRender: AfterAllRender
  });


});