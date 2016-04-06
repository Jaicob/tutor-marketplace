var TutorCardContainer = React.createClass({
	componentDidMount: function () {
		this.componentWillReceiveProps(this.props)
	},
	componentWillReceiveProps: function (nextProps) {
		this.setState({ loaded: false });

		var endpoint = API.endpoints.tutor.all({
			course_id: nextProps["course"]
		});

		var request = $.get(endpoint);

		request.success(function(data){
			this.setState({
				loaded: true,
				tutors: data
			})
		}.bind(this));

		request.error(function(){
			this.setState({
				error: true
			})
		}.bind(this));
	},
	getInitialState: function () {
	    return {
	    	loaded: false,
	    	error: false,
	    	tutors: []
	    };
	},
	showTutorCards: function() {
		return this.state.tutors.map(function(tutor){
			return <TutorCard search={this.props} tutor={tutor}/>;
		}.bind(this));
	},
	showLoadingScreen: function(){
		return (
			<p className="margin-top-2em">Loading...</p>
		);
		// return <TutorCardContainerLoadingScreen />;
	},
	showNoTutorsError: function(){
		return (
			<p className="margin-top-2em">No Tutors Found</p>
		);
		// return <TutorCardContainerNoTutorsError />;
	},
	showNetworkError: function(){
		return (
			<p className="margin-top-2em">There was a network error. Please refresh the page.</p>
		);
		// return <TutorCardContainerNetworkError />;
	},
	getResultScreen: function(){
		var state = this.state;
		var loaded = state.loaded;
		if(state.error) {
			return this.showNetworkError();
		} else {
			if(state.loaded == false) {
				return this.showLoadingScreen();
			} else {
				if (state.tutors.length > 0) {
					return this.showTutorCards();
				} else {
					return this.showNoTutorsError();
				}
			}
		}
	},
	render: function(){
		return(
			<div className="cards">
				{ this.getResultScreen() }
			</div>
		);
	}
});
