var TutorCard = React.createClass({
	render: function(){
		var tutor = this.props.tutor;
    var profile_pic_url = "/public/uploads/" + tutor.profile_pic.url;
		return (
			<div className="tutor-card">
        <img className="tutor-card__picture" src={profile_pic_url}></img>
        <div className="tutor-card__rate">${tutor.rate}</div>
        <div className="tutor-card__name">{tutor.user.first_name} {tutor.user.last_name}</div>
        <div className="tutor-card__description">
          <ul className="tutor-card__description--container">
            <li className="tutor-card__description--item">{tutor.degree + " " + tutor.major + " '" + tutor.graduation_year.slice(2, 4)}</li>
            <li className="tutor-card__description--item">{tutor.extra_info}</li>
          </ul>
        </div>
        <div className="btn--book-now--wide">
          Book Now
        </div>
			</div>
		);
	}
});