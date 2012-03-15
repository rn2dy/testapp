require "spec_helper"

describe Notifier do
  describe "invited" do
    let(:mail) { Notifier.invited }

    it "renders the headers" do
      mail.subject.should eq("Invited")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "resend_password" do
    let(:mail) { Notifier.resend_password }

    it "renders the headers" do
      mail.subject.should eq("Resend password")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
