describe "User API" do
  let(:user) { create(:user) }

  it "Returns all users" do 
    create_list(:user, 3)
    get "/api/v1/tutors"
    expect(response).to be_success
    expect(json.length).to eq(3)
  end


end