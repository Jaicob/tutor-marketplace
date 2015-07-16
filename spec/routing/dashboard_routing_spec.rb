require 'rails_helper'

describe "Dashboard routing" do

  let(:user) { create(:user) }

  it "routes User dashboard correctly" do

    expect(get: "/#{user.id}/dashboard/home").to route_to(
      controller: "dashboard", action: "home", id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/schedule").to route_to(
      controller: "dashboard", action: "schedule", id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/courses").to route_to(
      controller: "dashboard", action: "courses", id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/profile").to route_to(
      controller: "dashboard", action: "profile", id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/settings").to route_to(
      controller: "dashboard", action: "settings", id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/edit_profile").to route_to(
      controller: "dashboard", action: "edit_profile", id: user.id.to_s)
  end
end