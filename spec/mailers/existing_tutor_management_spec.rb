require "rails_helper"

RSpec.describe ExistingTutorManagement, type: :mailer do
  describe "welcome" do
    let(:mail) { ExistingTutorManagement.welcome }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "activation" do
    let(:mail) { ExistingTutorManagement.activation }

    it "renders the headers" do
      expect(mail.subject).to eq("Activation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
