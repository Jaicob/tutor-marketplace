var TutorCard = React.createClass({
	render: function(){
		var tutor = this.props.tutor;
    var profile_pic_url = "/public/uploads/" + tutor.profile_pic_url;
		return (
      <div className="card">
        <div className="card-image">
          <img src="http://placehold.it/200x200" alt="4x3 Image"></img>
        </div>
        <div className="card-header">
          <h3 className="title">{tutor.user.first_name + " " + tutor.user.last_name}</h3>
        </div>
        <div className="card-copy">
          <ul className="tutor-qualifications">
            <li>{tutor.degree + ', ' + tutor.major + ' ' + tutor.graduation_year}</li>
            <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</li>
            <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</li>
          </ul>
          <div className="btn" onClick={
            function () {
              swal("booked!")
            }
          }>Book Now</div>
        </div>
        <div className="cost">
          <p>$25</p>
        </div>
      </div>
		);
	}
});