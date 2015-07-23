require 'rails_helper'

describe "Dashboard routing" do

  let(:user) { create(:user) }

  it "routes User dashboard correctly" do

    expect(get: "/#{user.id}/dashboard/home").to route_to(
      'dashboard/home#index', id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/schedule").to route_to(
      'dashboard/schedule#index', id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/courses").to route_to(
      'dashboard/courses#index', id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/profile").to route_to(
      'dashboard/profile#index', id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/edit_profile").to route_to(
      'dashboard/profile#edit', id: user.id.to_s)

    expect(get: "/#{user.id}/dashboard/settings").to route_to(
      'dashboard/settings#index', id: user.id.to_s)
  end
end