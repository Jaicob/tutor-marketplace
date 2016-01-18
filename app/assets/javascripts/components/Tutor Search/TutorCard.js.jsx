var TutorCard = React.createClass({
	render: function(){
    var search = ""
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }

		var tutor = this.props.tutor;
    var profile_pic_url = tutor.profile_pic.thumb.url;


    var degree = function (degree, major, graduation_year) {
      if(major.length > 18) {
        var major = major.slice(0, 18);
      }
      return (
        <p className="degree">{degree + ', ' + major + " '" + String(graduation_year).substr(graduation_year.length - 2)}</p>
      )
    }

    var additional_degrees = function (additional_degrees) {
      var adjustButtonPosition = true;
      
      if(additional_degrees != null && additional_degrees.length > 35) {
        var additional_degrees = additional_degrees.slice(0, 35);
      }

      if(additional_degrees != null && additional_degrees.length > 0) {
        return (
            <p>
              <i className="fi-plus"></i>
              {additional_degrees}
            </p>
        )
      } else {
         // returns without plus sign if there is nothing to display
        return (
            <p className="hidden-filler-text">X</p>
        )
      }
    }

    var desc = function (tutor, extra_info) {
      if(extra_info.length > 100){
        return (
          <p>{extra_info.slice(0, 100) + "..."}</p>
        )
      }
      else {
        return (
          <p>{extra_info}</p>
        )
      }
    }

    var full_price = function(tutor_rate) {
      return (
        Math.round(tutor_rate * 1.15)
      )
    }

		return (
        <div className="card">
          <div className="card-content">
            <a href={"/tutors/" + tutor.slug + search} data={"from-search"}>
              <div className="profile-pic-box">
                <img src={profile_pic_url} alt="Profile Picture" className="profile-pic"></img>
              </div>
            </a>
            <div className="banner-box">
              <div className="banner-row">
                <p className="name">{tutor.user.first_name + " " + tutor.user.last_name[0] + "."}</p>
                <p className="price">${full_price(tutor.rate)}</p>
              </div>
              <div className="banner-row">
                <i className="fi-book-bookmark"></i>
                <p className="degree">{degree(tutor.degree, tutor.major, tutor.graduation_year)}</p>
              </div>
            </div>
            <div className="additional_degrees">
                {additional_degrees(tutor.additional_degrees)}
              </div>
            <div className="statements-box">
              <a href={"/tutors/" + tutor.slug} className="see-more">
                <div className="statement">
                  {desc(tutor, tutor.extra_info_1)}
                </div>
                <div className="statement">
                  {desc(tutor, tutor.extra_info_2)}
                </div>
                <div className="statement">
                  {desc(tutor, tutor.extra_info_3, tutor.id)}
                </div>
              </a>
            </div>
          </div>
          <a href={"/tutors/" + tutor.slug + search + "#select-times"} data={"from-search"}>
            <div className="custom-button full-width">Book Now
            </div>
          </a>
        </div>
		);
	}
});