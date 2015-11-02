$(document).ready(function(){

  var x = 'fuckin'
  console.log('I WAS CALLED');
  console.log('Interpolation' + x + 'works');

  function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
  }
  var requestFromHome = getParameterByName('from_home');

  console.log("This is the variable" + requestFromHome);

  console.log(requestFromHome == 'true');
  
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

    // $("#school")[0].selectedIndex = 0;
    // $("#subject")[0].selectedIndex = 0;
    // $("#course")[0].selectedIndex = 0;

  }  
});