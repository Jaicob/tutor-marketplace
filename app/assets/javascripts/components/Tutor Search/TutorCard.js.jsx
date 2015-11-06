var TutorCard = React.createClass({
	render: function(){
    var search = ""
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }
		var tutor = this.props.tutor;
    var profile_pic_url = "http://d1nt4a7y8dwdsx.cloudfront.net/wp-content/uploads/2015/04/Bernie-Sanders-AP77174442780.jpg";  
    // change to tutor.profile_pic.url 
    var desc = function (extra_info) {
      if(extra_info.length > 110){
        return (
          <p>
            {extra_info.slice(0, 110) + "..."}
            <a href={"/tutors/" + tutor.user.slug} className="see-more">See More</a>
          </p>
          )
      }
      else {
          return <p>{extra_info}</p>
      }
    }
		return (
        <div className="card">
          <div className="profile-pic-box">
            <img src={profile_pic_url} alt="Profile Picture"></img>
          </div>
          <div className="banner-box">
            <div className="banner-row">
              <p className="name">{tutor.user.first_name + " " + tutor.user.last_name[0] + "."}</p>
              <p className="price">${tutor.rate}</p>
            </div>
            <div className="banner-row">
              <i className="fi-book-bookmark"></i>
              <p className="degree">{tutor.degree + ', ' + tutor.major + ' ' + tutor.graduation_year}</p>
            </div>
          </div>
          <div className="statements-box">
            <div className="statement">
              {desc(tutor.extra_info_1)}
            </div>
            <div className="statement">
              {desc(tutor.extra_info_2)}
            </div>
            <div className="statement">
              {desc(tutor.extra_info_3)}
            </div>
          </div>
          <div className="custom-button full-width">Book Now</div>
        </div>
		);
	}
});