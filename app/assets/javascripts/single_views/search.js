$(document).ready(function(){
	var updateReactComponents = function(){
		var schoolId = $("#school").val();
		var courseId = $("#course").val();
		React.render(
		    React.createElement(TutorCardContainer, {school: schoolId, course: courseId}),
		    document.querySelector('#tutorcardcontainer')
		);
	}
	$("#school").on("change", updateReactComponents);
	$("#course").on("change", updateReactComponents);
});