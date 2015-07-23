$(document).ready(function(){
  $("#subject").remoteChainedTo({
    parents: "#school",
    url: function(){
      return API.endpoints.subjects({
        school_id: $("#school").val()
      })
    },
    data_formatter: function(data){
      return data.map(function(subject){
          return [subject.id, subject.name];
      });
    }
  });

  $("#course").remoteChainedTo({
    parents: "#school, #subject",
    url: function(){
      return API.endpoints.courses({
        school_id:  $("#school").val(),
        subject_id: $("#subject").val()
      })
    },
    data_formatter: function(data){
      return data.map(function(course){
        return [course.id, course.call_number + " (" + course.friendly_name + ")"];
      });
    }
  });
});
