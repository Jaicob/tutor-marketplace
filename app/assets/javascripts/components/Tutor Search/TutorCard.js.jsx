var TutorCard = React.createClass({
	render: function(){
    var search = ""
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }
		var tutor = this.props.tutor;
    var profile_pic_url = "/public/uploads/" + tutor.profile_pic_url;
		return (
      <div className="card">
        <a href={"/tutors/" + tutor.user.slug}>
          <div className="card-image">
            <img src={profile_pic_url} alt="Profile Picture"></img>
          </div>
        </a>
        <div className="card-header">
          <h3 className="title">{tutor.user.first_name + " " + tutor.user.last_name}</h3>
        </div>
        <div className="card-copy">
          <ul className="tutor-qualifications">
            <li>{tutor.degree + ', ' + tutor.major + ' ' + tutor.graduation_year}</li>
            <li>{tutor.extra_info}</li>
          </ul>
          <a href={"/tutors/" + tutor.user.slug + search + "#book"} className="btn">Book Now</a>
        </div>
        <div className="cost">
          <p>${tutor.rate}</p>
        </div>
      </div>
		);
	}
});