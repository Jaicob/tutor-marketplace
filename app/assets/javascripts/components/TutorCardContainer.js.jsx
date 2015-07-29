var TutorCardContainer = React.createClass({
	componentWillReceiveProps: function (nextProps) {
		var endpoint = API.endpoints.courses({
			school_id: nextProps["school"],
			subject_id: nextProps["subject"]
		})
		$.get(endpoint).success(function(data){
			console.log(data);
			this.setState({
				tutors: data
			})
		}.bind(this))
	},
	getInitialState: function () {
	    return {
	    	tutors: []
	    };
	},
	render: function(){
		return <div>
			{
				this.state.tutors.map(function(tutor){
					return <TutorCard tutor={tutor} />
				})
			}
		</div>
	}
})