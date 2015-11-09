var TutorCardContainer = React.createClass({
	displayName: "TutorCardContainer",

	componentDidMount: function () {
		this.componentWillReceiveProps(this.props);
	},
	componentWillReceiveProps: function (nextProps) {
		this.setState({ loaded: false });

		var endpoint = API.endpoints.tutor.all({
			school_id: nextProps["school"],
			course_id: nextProps["course"]
		});

		var request = $.get(endpoint);

		request.success((function (data) {
			this.setState({
				loaded: true,
				tutors: data
			});
		}).bind(this));

		request.error((function () {
			this.setState({
				error: true
			});
		}).bind(this));
	},
	getInitialState: function () {
		return {
			loaded: false,
			error: false,
			tutors: []
		};
	},
	showTutorCards: function () {
		return this.state.tutors.map((function (tutor) {
			return React.createElement(TutorCard, { search: this.props, tutor: tutor });
		}).bind(this));
	},
	showLoadingScreen: function () {
		return "Loading...";
		// return <TutorCardContainerLoadingScreen />;
	},
	showNoTutorsError: function () {
		return "No Tutors Found";
		// return <TutorCardContainerNoTutorsError />;
	},
	showNetworkError: function () {
		return "Network error";
		// return <TutorCardContainerNetworkError />;
	},
	getResultScreen: function () {
		var state = this.state;
		var loaded = state.loaded;
		if (state.error) {
			return this.showNetworkError();
		} else {
			if (state.loaded == false) {
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
	render: function () {
		return React.createElement(
			"div",
			{ className: "cards" },
			this.getResultScreen()
		);
	}
});