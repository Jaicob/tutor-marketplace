var TutorCard = React.createClass({
  displayName: "TutorCard",

  render: function () {
    var search = "";
    if (this.props.search && this.props.search.course != -1) {
      var search = "?course=" + this.props.search.course;
    }
    var tutor = this.props.tutor;
    var profile_pic_url = "http://d1nt4a7y8dwdsx.cloudfront.net/wp-content/uploads/2015/04/Bernie-Sanders-AP77174442780.jpg";
    // change to tutor.profile_pic.url
    var desc = function (extra_info) {
      if (extra_info.length > 100) {
        return React.createElement(
          "p",
          null,
          extra_info.slice(0, 100) + "...",
          React.createElement(
            "a",
            { href: "/tutors/" + tutor.user.slug, className: "see-more" },
            "See More"
          )
        );
      } else {
        return React.createElement(
          "p",
          null,
          extra_info
        );
      }
    };
    return React.createElement(
      "div",
      { className: "card" },
      React.createElement(
        "div",
        { className: "profile-pic-box" },
        React.createElement("img", { src: profile_pic_url, alt: "Profile Picture" })
      ),
      React.createElement(
        "div",
        { className: "banner-box" },
        React.createElement(
          "div",
          { className: "banner-row" },
          React.createElement(
            "p",
            { className: "name" },
            tutor.user.first_name + " " + tutor.user.last_name[0] + "."
          ),
          React.createElement(
            "p",
            { className: "price" },
            "$",
            tutor.rate
          )
        ),
        React.createElement(
          "div",
          { className: "banner-row" },
          React.createElement("i", { className: "fi-book-bookmark" }),
          React.createElement(
            "p",
            { className: "degree" },
            tutor.degree + ', ' + tutor.major + ' ' + tutor.graduation_year
          )
        )
      ),
      React.createElement(
        "div",
        { className: "statements-box" },
        React.createElement(
          "div",
          { className: "statement" },
          desc(tutor.extra_info_1)
        ),
        React.createElement("div", { className: "statement-divider-line" }),
        React.createElement(
          "div",
          { className: "statement" },
          desc(tutor.extra_info_2)
        ),
        React.createElement("div", { className: "statement-divider-line" })
      ),
      React.createElement(
        "div",
        { className: "custom-button full-width" },
        "Book Now"
      )
    );
  }
});