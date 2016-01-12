$(document).ready(function(){

  function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }
  var indirectSearch = getParameterByName('indirect_search');
  
  if (indirectSearch == 'true') {
    var courseId = parseInt(getParameterByName('course_id'));
    React.render(
      React.createElement(TutorCardContainer, {
        course: courseId
      }),
      document.querySelector('#tutorCardContainer')
    );
  }  

});
