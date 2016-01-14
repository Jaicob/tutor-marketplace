$(document).ready(function(){
  var loadingText = "Loading..."
  var all = $("#subject").data('all');
  // for students searching site (limited to subjects and courses with active tutors)
  
  $("#subject").remoteChainedTo({
    parents: "#school",
    loading : loadingText,
    url: function(){
      return API.endpoints.subjects({
        school_id: $("#school").val()
      },all)
    },
    data_formatter: function(data){
      if (typeof data == 'string') {
        return [["", data]];
      };

      return data.map(function(subject){
        return [subject.id, subject.name];
      });
    }
  });

  $("#course").remoteChainedTo({
    parents: "#subject",
    loading : loadingText,
    url: function(){
      return API.endpoints.courses({
        school_id:  $("#school").val(),
        subject_id: $("#subject").val()
      })
    },
    data_formatter: function(data){
      if (typeof data == 'string') {
        return [["", data]];
      };

      return data.map(function(course){
        return [course.id, course.call_number + " (" + course.friendly_name + ")"];
      });
    }
  });

  // for Tutors (which must go to a different endpoint to access ALL subjects and courses - not just those with active tutors)

  $("#subjects-for-tutors").remoteChainedTo({
    parents: "#school",
    loading : loadingText,
    url: function(){
      return API.endpoints.subjects_for_tutors({
        school_id: $("#school").val()
      })
    },
    data_formatter: function(data){
      if (typeof data == 'string') {
        return [["", data]];
      };

      return data.map(function(subject){
        return [subject.id, subject.name];
      });
    }
  });

  $("#courses-for-tutors").remoteChainedTo({
    parents: "#subjects-for-tutors",
    loading : loadingText,
    url: function(){
      return API.endpoints.courses_for_tutors({
        school_id:  $("#school").val(),
        subject_id: $("#subjects-for-tutors").val()
      })
    },
    data_formatter: function(data){
      if (typeof data == 'string') {
        return [["", data]];
      };

      return data.map(function(course){
        return [course.id, course.call_number + " (" + course.friendly_name + ")"];
      });
    }
  });


});
