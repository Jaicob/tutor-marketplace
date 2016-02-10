// $(document).ready(function(){
// 	var updateReactComponents = function(){
// 		var schoolId = $("#school").val();
// 		var courseId = $("#course").val();
// 		if ($.isNumeric(schoolId) && $.isNumeric(courseId)) {
// 			React.render(
// 			    React.createElement(TutorCardContainer, {
// 			    	school: schoolId,
// 			    	course: courseId
// 			    }),
// 			    document.querySelector('#tutorCardContainer')
// 			);
// 		} else {
// 			swal("Uh-oh", "Please select a school and a course.", "error");
// 		}
// 	}

// 	$("#school")[0].selectedIndex = 0;
// 	$("#subject")[0].selectedIndex = 0;
// 	$("#course")[0].selectedIndex = 0;

// 	$("#tutorSearchButton").on("click", updateReactComponents);
// });