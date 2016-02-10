$(document).ready(function(){
	var updateReactComponents = function(){
		console.log('CALLED!');
		var schoolId = $("#school").val();
		var courseId = $("#course").val();
		console.log('school_id=' + schoolId);
		console.log('course_id=' + courseId);
		if ($.isNumeric(schoolId) && $.isNumeric(courseId)) {
			React.render(
			    React.createElement(TutorCardContainer, {
			    	school: schoolId,
			    	course: courseId
			    }),
			    document.querySelector('#tutorCardContainer')
			);
		} else {
			swal("Uh-oh", "Please select a school and a course.", "error");
		}
	}

	$("#school")[0].selectedIndex = 0;
	$("#subject")[0].selectedIndex = 0;
	$("#course")[0].selectedIndex = 0;

	$("#course-search-submit").on("click", updateReactComponents);
});