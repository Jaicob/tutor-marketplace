$(document).ready(function(){

  function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }
  var requestFromHome = getParameterByName('from_home');
  
  if (requestFromHome == 'true') {
    var schoolId = parseInt(getParameterByName('school_id'));
    var courseId = parseInt(getParameterByName('course_id'));
    React.render(
      React.createElement(TutorCardContainer, {
        school: schoolId,
        course: courseId
      }),
      document.querySelector('#tutorCardContainer')
    );
  }  
});
