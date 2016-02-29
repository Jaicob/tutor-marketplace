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

    var tutor_stats = function (students, appointments, approval) {
      var stats =   (
                     <div>
                        <div className="row stat-row">
                           <div className="columns small-8">
                            <span data-tooltip aria-haspopup="true" className="has-tip" data-disable-hover='false' tabindex="3" title="Percent who found their session helpful">{"Approval Rating"} </span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin text-right"><i className="icon fi-like"></i><span className="stat-text">{approval + "%"}</span></p></span>
                          </div>
                        </div>
                        <div className="row stat-row clearfix">
                           <div className="columns small-8">
                             <span data-tooltip aria-haspopup="true" className="has-tip" data-disable-hover='false' tabindex="2" title="Number of sessions tutored">{"Appointments"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin text-right"><i className="icon fi-list-thumbnails"></i><span className="stat-text">{appointments}</span></p></span>
                          </div>
                        </div>
                         <div className="row stat-row">
                          <div className="columns small-8">
                            <span data-tooltip aria-haspopup="true" className="has-tip"  tabindex="1" title="Students Tutored">{"Students"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin text-right"><i className="icon fi-torsos-female-male"></i><span className="stat-text">{students}</span></p></span>
                          </div>
                        </div>
                        <div className="row">
                          <div className="columns small-12 small-centered ">
                            <p className="text-center even-padding"><a href="#">{"See Full Profile"}</a></p>
                          </div>
                        </div>
                    </div>
                    )

        if ( approval < 10 ) {
          stats =   (
                     <div>
                        <div className="row stat-row">
                           <div className="columns small-8">
                            <span data-tooltip aria-haspopup="true" className="has-tip" data-disable-hover='false' tabindex="3" title="There is no feedback for this tutor yet">{"Approval Rating"} </span>
                          </div>
                          <div className="columns small-4">
                            <span>
                              <p className="no-bottom-margin text-right">
                                <i className="icon fi-like"></i>
                                <span className="stat-text">
                                  <span data-tooltip aria-haspopup="true" className="has-tip" data-disable-hover='false' tabindex="6" title="There is no feedback for this tutor yet">
                                     {"--"} 
                                  </span>
                                </span>
                              </p>
                            </span>
                          </div>
                        </div>
                        <div className="row stat-row clearfix">
                           <div className="columns small-8">
                             <span data-tooltip aria-haspopup="true" className="has-tip" data-disable-hover='false' tabindex="2" title="Number of sessions tutored">{"Appointments"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin text-right"><i className="icon fi-list-thumbnails"></i><span className="stat-text">{appointments}</span></p></span>
                          </div>
                        </div>
                         <div className="row stat-row">
                          <div className="columns small-8">
                            <span data-tooltip aria-haspopup="true" className="has-tip"  tabindex="1" title="Students Tutored">{"Students"}</span>
                          </div>
                          <div className="columns small-4">
                            <span><p className="no-bottom-margin text-right"><i className="icon fi-torsos-female-male"></i><span className="stat-text">{students}</span></p></span>
                          </div>
                        </div>
                        <div className="row">
                          <div className="columns small-12 small-centered ">
                            <p className="text-center even-padding"><a href="#">{"See Full Profile"}</a></p>
                          </div>
                        </div>
                    </div>
                    )
        }
  
        if ( appointments < 2 ) {
          stats = (
            <div>
              <div className="row" id="new-tutor-container">
                <div className="columns small-3">
                  <p className="text-center">
                    <i id="new-tutor" className="fi-trophy margin-right-1em"></i>
                  </p>
                </div>
                <div className="columns small-9">
                   <p>{"We are excited to introduce " + tutor.user.first_name + " to Axon. Book this tutor now for 10% off!" }</p>
                </div>
              </div>
              <div className="row">
                <div className="columns small-12 small-centered ">
                  <p className="text-center even-padding"><a href="#">{"See Full Profile"}</a></p>
                </div>
              </div>
            </div>
            )
        }

      return stats;
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
            <div className="tutor_stats">
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