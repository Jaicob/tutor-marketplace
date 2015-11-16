var LocationSelector = React.createClass({
  componentWillMount: function () {
    this.setDelegates();
  },
  getInitialState: function () {
    return {
      location: this.props.selectedLocation || ""
    };
  },
  setDelegates: function () {
    navBar = this.props.UINavigationBarDelegate;
    navBar.titleBarText = "Suggest a Location";
    navBar.backButtonText = "Change times"
    navBar.forwardButtonText = "Proceed to checkout"

    navBar.forwardButtonClick = function(update){
      this.props.handleLocation(this.state.location);
      this.props.makeAppointment(update);
    }.bind(this);

    navBar.backButtonClick = function(update){
      this.props.handleLocation(this.state.location);
      update();
    }.bind(this);;

    this.props.updateDelegate(navBar);
  },
  handleChange: function (event) {
    this.setState({location: event.target.value});
  },
  render: function () {
    return (
      <div className="main-view">
        <div className="location-selector">
          <div className="row center">
            <div className="medium-12 columns">
              All of our tutors and students meet right on or just around campus. Some popular meeting locations are:
            </div>
          </div>
          <div className="row top-buffer bottom-buffer center">
            <div className="medium-4 columns">
              <img className="th bottom-buffer" src="http://placehold.it/100x100"></img><br></br>
              School Libraries
            </div>
            <div className="medium-4 columns">
              <img className="th bottom-buffer" src="http://placehold.it/100x100"></img><br></br>
              Coffee Shops
            </div>
            <div className="medium-4 columns">
              <img className="th bottom-buffer" src="http://placehold.it/100x100"></img><br></br>
              Student Centers
            </div>
          </div>
          <hr></hr>
          <div className="row bottom-buffer">
            <div className="medium-12 columns">
              {this.props.tutor_name} will contact you and confirm the final location, but would you like to suggest a specific meeting location?
            </div>
          </div>
          <input type="text" className="suggestion" placeholder="Jittery Joe's Coffee Shop at Five Points" value={this.state.location} onChange={this.handleChange}></input>
        </div>
      </div>
    );
  }
});