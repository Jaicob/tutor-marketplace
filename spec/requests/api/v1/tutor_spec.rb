describe "Tutor API" do 
  let(:tutor) { create(:tutor) }

  it "Returns all tutors" do
    create_list(:tutor, 10)
    get "/api/v1/tutors"
    expect(response).to be_success
    expect(json.length).to eq(10)
  end

  it "Returns a specific tutor" do 
    get "/api/v1/tutors/#{tutor.id}"
    expect(response).to be_success
    expect(json['id']).to eq(tutor.id)
  end

  it "Updates a specific tutor's attributes" do 
    skip
  end

end