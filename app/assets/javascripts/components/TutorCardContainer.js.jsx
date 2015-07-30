var TutorCardContainer = React.createClass({
	componentWillReceiveProps: function (nextProps) {
		var endpoint = API.endpoints.tutors({
			school_id: nextProps["school"],
			course_id: nextProps["course"]
		});
		$.get(endpoint).success(function(data){
			this.setState({ tutors: data })
		}.bind(this));
	},
	getInitialState: function () {
	    return {
	    	tutors: []
	    };
	},
	render: function(){
		return(
			<div>
				{
					this.state.tutors.map(function(tutor){
						return <TutorCard tutor={tutor} />
					})
				}
			</div>
		);
	}
});
