var API_LOCATION = "/api/v1"
String.prototype.toTitleCase = function () {
    var smallWords = /^(a|an|and|as|at|but|by|en|for|if|in|nor|of|on|or|per|the|to|vs?\.?|via)$/i;
    return this.replace(/[A-Za-z0-9\u00C0-\u00FF]+[^\s-]*/g, function (match, index, title) {
        if (index > 0 && index + match.length !== title.length && match.search(smallWords) > -1 && title.charAt(index - 2) !== ":" && (title.charAt(index + match.length) !== '-' || title.charAt(index - 1) === '-') && title.charAt(index - 1).search(/[^\s-]/) < 0) {
            return match.toLowerCase();
        }
        if (match.substr(1).search(/[A-Z]|\../) > -1) {
            return match;
        }
        return match.charAt(0).toUpperCase() + match.substr(1);
    });
};

Array.prototype.unique = function (key) {
  return this.map(key).filter( function (item, pos) {
    return this.indexOf(item) == pos;
  }.bind(this));
};

var API = {
    endpoints: {
        subjects: function (data) { // { school_id }
            return API_LOCATION + "/schools/" + data["school_id"] + "/subjects/"
        },
        courses: function (data) { // { school_id, subject_id }
            return API_LOCATION + "/schools/" + data["school_id"] + "/subjects/" + data["subject_id"] + "/courses/"
        },
        tutor_slots: {
            get: function (data) { // { tutor_id }
                return API_LOCATION + "/tutors/" + data["tutor_id"] + "/slots"
            },
            update: function (data) { // { tutor_id }
                return API_LOCATION + "/tutors/" + data["tutor_id"] + "/slots"
            },
            create: function (data) { // { tutor_id }
                return API_LOCATION + "/tutors/" + data["tutor_id"] + "/slots"
            }
        },
        tutor: {
            all: function (data) { // { school_id[, course_id][, dow] }
                return API_LOCATION + "/search/tutors?" + $.param(data)
            },
            courses: function(data) {
                return API_LOCATION + "/tutors/" + data["tutor_id"] + "/courses/"
            }
        }
       students: function(data) {
        return API_LOCATION + "/payments/current_student/"
       }
    }
};