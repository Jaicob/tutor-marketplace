$(document).ready(function(){
  var loadingText = "Loading..."

  $("#subject").remoteChainedTo({
    parents: "#school",
    loading : loadingText,
    url: function(){
      return API.endpoints.subjects({
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
});
