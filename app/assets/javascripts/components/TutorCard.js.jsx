var TutorCard = React.createClass({
	render: function(){
		var tutor = this.props.tutor;
		return (
			<div>
				{tutor}
			</div>
		);
	}
});