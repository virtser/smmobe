require 'spec_helper'

describe User do
  # pending "add some examples to (or delete) #{__FILE__}"

  before { @user = User.new(name: "Example User", email: "user@example.com", phone: "054-4472571", password: "123456") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }
  it { should respond_to(:password) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when phone is not present" do
    before { @user.phone = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = " " }
    it { should_not be_valid }
  end
end