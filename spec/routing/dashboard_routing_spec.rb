require 'rails_helper'

describe "Dashboard routing" do 

  let(:user) { create(:user) } 

  it "routes User dashboard correctly" do

    expect(get: "/#{user.id}/dashboard").to route_to(
      controller: "dashboard", action: "home", id: user.id.to_s)
    
    expect(get: "/#{user.id}/schedule").to route_to(
      controller: "dashboard", action: "schedule", id: user.id.to_s)
    
    expect(get: "/#{user.id}/courses").to route_to(
      controller: "dashboard", action: "courses", id: user.id.to_s)

    expect(get: "/#{user.id}/profile").to route_to(
      controller: "dashboard", action: "profile", id: user.id.to_s)

    expect(put: "/#{user.id}/profile").to route_to(
      controller: "dashboard", action: "update_profile", id: user.id.to_s)

    expect(get: "/#{user.id}/settings").to route_to(
      controller: "dashboard", action: "settings", id: user.id.to_s)

    expect(put: "/#{user.id}/settings").to route_to(
      controller: "dashboard", action: "update_settings", id: user.id.to_s)

    expect(put: "/#{user.id}/change_profile_pic").to route_to(
      controller: "dashboard", action: "change_profile_pic", id: user.id.to_s)

    expect(put: "/#{user.id}/save_profile_pic_crop").to route_to(
      controller: "dashboard", action: "save_profile_pic_crop", id: user.id.to_s)

  end

end