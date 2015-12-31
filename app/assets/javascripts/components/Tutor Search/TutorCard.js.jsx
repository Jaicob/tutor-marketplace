var TutorCard = React.createClass({
	render: function(){
    var search = ""
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }

		var tutor = this.props.tutor;
    var profile_pic_url = tutor.profile_pic.url;

    var desc = function (tutor, extra_info) {
      if(tutor.additional_degrees) {
        if(extra_info.length > 100){
          return (
            <p>&#8226;
              {extra_info.slice(0, 100) + "..."}
              <a href={"/tutors/" + tutor.slug} className="see-more">See More</a>
            </p>
            )
        }
        else {
            return <p>&#8226; {extra_info}</p>
        }
      }
      else {
        if(extra_info.length > 130){
          return (
            <p>&#8226;
              {extra_info.slice(0, 130) + "..."}
              <a href={"/tutors/" + tutor.slug} className="see-more">See More</a>
            </p>
            )
        }
        else {
            return <p>&#8226; {extra_info}</p>
        }
      }
    }
    var additional_degrees = function (tutor) {
      if(tutor.additional_degrees){
        var adjustButtonPosition = true;
        return (
            <p>
              <i className="fi-plus"></i>
              {tutor.additional_degrees}
            </p>
        )
      }
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
                <p className="price">${tutor.rate}</p>
              </div>
              <div className="banner-row">
                <i className="fi-book-bookmark"></i>
                <p className="degree">{tutor.degree + ', ' + tutor.major + " '" + String(tutor.graduation_year).substr(tutor.graduation_year.length - 2)}</p>
              </div>
            </div>
            <div className="additional_degrees">
                {additional_degrees(tutor)}
              </div>
            <div className="statements-box">
              <div className="statement">
                {desc(tutor, tutor.extra_info_1)}
              </div>
              <div className="statement">
                {desc(tutor, tutor.extra_info_2)}
              </div>
            </div>
          </div>
          <a href={"/tutors/" + tutor.slug + search} data={"from-search"}>
            <div className="custom-button full-width adust-position{adjustButtonPosition}">Book Now
            </div>
          </a>
        </div>
		);
	}
});