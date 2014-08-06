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

  # Name tests
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { @user.name = "abc" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm" }
    it { should_not be_valid }
  end

  # Email tests
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email is not correct" do
    before { @user.email = "a@a" }
    it { should_not be_valid }
  end

  # Phone tests
  describe "when phone is not present" do
    before { @user.phone = " " }
    it { should_not be_valid }
  end

  describe "when phone is too short" do
    before { @user.phone = "12345" }
    it { should_not be_valid }
  end

  describe "when phone is too long" do
    before { @user.phone = "123456789012345678901" }
    it { should_not be_valid }
  end

  # Password tests
  describe "when password is not present" do
    before { @user.password = " " }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "12345" }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "1234567890123" }
    it { should_not be_valid }
  end
end