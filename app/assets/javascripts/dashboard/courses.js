// api = "/api/v1"

// school  =  $("#school")
// subject =  $("#subject")
// course  =  $("#course")

// school_endpoint  = api + "/schools"
// subject_endpoint = api + "/schools/" + school.value + "/subjects/"
// course_endpoint  = api + "/schools/" + school.value + "/courses/subject/" + subject.value

// $('#add_course_box').cascadingDropdown({
//     selectBoxes: [
//         {
//             selector: '#school',
//             source: function(request, response) {
//                 $.getJSON(school_endpoint, request, function(data) {
//                     response($.map(data, function(item, index) {
//                         return {
//                             label: item.name,
//                             value: item.id,
//                             selected: false
//                         };
//                     }));
//                 });
//             }
//         },
//         {
//             selector: '#subject',
//             requires: ['#school'],
//             requireAll: true,
//             source: function(request, response) {
//                 $.getJSON(subject_endpoint, request, function(data) {
//                     response($.map(data, function(item, index) {
//                         return {
//                             label: item,
//                             value: encodeURIComponent(item.split(" ").join("_")),
//                             selected: false,
//                         };
//                     }));
//                 });
//             }
//         },
//         {
//             selector: '#course',
//             requires: ['#school', '#subject'],
//             requireAll: true,
//             source: function(request, response) {
//                 $.getJSON(course_endpoint, request, function(data) {
//                     response($.map(data, function(item, index) {
//                         return {
//                             label: item.call_number + " (" + item.friendly_name + ")",
//                             value: item.id,
//                             selected: false
//                         };
//                     }));
//                 });
//             },
//             onChange: function(event, value, requiredValues){
//                 // do stuff
//             }
//         }
//     ]
// });