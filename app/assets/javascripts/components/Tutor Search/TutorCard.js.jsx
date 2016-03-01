var TutorCard = React.createClass({
	render: function(){
    var search = ""
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }

		var tutor = this.props.tutor;
    var profile_pic_url = tutor.profile_pic.thumb.url + "?reload";


    var degree = function (degree, major, graduation_year) {
      if(major.length > 18) {
        var major = major.slice(0, 18);
      }
      return (
        <p className="degree">{degree + ', ' + major + " '" + String(graduation_year).substr(graduation_year.length - 2)}</p>
      )
    }

    var tutor_stats = function (students, appointments, approval) {
      var stats =   (
                     <div>
                        <div className="row small-collapse stat-row">
                           <div className="columns small-8">
                            <span>{"Approval Rating"} </span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin center"><i className="icon fi-like"></i><span className="stat-text">{approval + "%"}</span></p></span>
                          </div>
                        </div>
                        <div className="row small-collapse stat-row clearfix">
                           <div className="columns small-8">
                             <span>{"Appointments"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin center"><i className="icon fi-list-thumbnails"></i><span className="stat-text">{appointments}</span></p></span>
                          </div>
                        </div>
                         <div className="row small-collapse stat-row">
                          <div className="columns small-8">
                            <span>{"Students"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin center"><i className="icon fi-torsos-female-male"></i><span className="stat-text">{students}</span></p></span>
                          </div>
                        </div>
                        <div className="row">
                          <div className="columns small-12 small-centered ">
                            <p className="text-center even-padding">
                              <a href={"/tutors/" + tutor.slug + search} data={"from-search"}>{"See Full Profile"}</a>
                            </p>
                          </div>
                        </div>
                    </div>
                    )

        if ( approval < 33 ) {
          stats =   (
                     <div>
                        <div className="row small-collapse stat-row">
                           <div className="columns small-8">
                            <span>{"Approval Rating"}</span>
                          </div>
                          <div className="columns small-4">
                            <span>
                              <p className="no-bottom-margin center">
                                <i className="icon fi-like"></i>
                                <span className="stat-text">
                                  <span>
                                     {"--"} 
                                  </span>
                                </span>
                              </p>
                            </span>
                          </div>
                        </div>
                        <div className="row small-collapse stat-row clearfix">
                           <div className="columns small-8">
                             <span>{"Appointments"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin center"><i className="icon fi-list-thumbnails"></i><span className="stat-text">{appointments}</span></p></span>
                          </div>
                        </div>
                         <div className="row small-collapse stat-row">
                          <div className="columns small-8">
                            <span>{"Students"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin center"><i className="icon fi-torsos-female-male"></i><span className="stat-text">{students}</span></p></span>
                          </div>
                        </div>
                        <div className="row">
                          <div className="columns small-12 small-centered ">
                            <p className="text-center even-padding">
                              <a href={"/tutors/" + tutor.slug + search} data={"from-search"}>{"See Full Profile"}</a>
                            </p>
                          </div>
                        </div>
                    </div>
                    )
        }
  
        if ( appointments < 3 ) {
          stats = (
            <div>
              <div className="row">
                <div className="columns small-12">
                  <p className="text-center no-bottom-margin">
                    <i id="new-tutor-icon" className="fi-trophy"></i>
                  </p>
                </div>
                <div className="row">
                  <div className="columns small-12">
                     <p className="new-tutor-intro center">{"We are excited to introduce " + tutor.user.first_name + " to Axon. Book your first session with " + tutor.user.first_name + " for 10% off!" }</p>
                  </div>
                </div>
              </div>
              <div className="row">
                <div className="columns small-12 small-centered ">
                  <p className="text-center even-padding">
                    <a href={"/tutors/" + tutor.slug + search} data={"from-search"}>{"See Full Profile"}</a>
                  </p>
                </div>
              </div>
            </div>
            )
        }

      return stats;
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
            <div className="tutor-stats">
              {tutor_stats(tutor.students, tutor.appointments, tutor.approval)} 
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
