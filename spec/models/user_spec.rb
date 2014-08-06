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
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { @user.name = "a" * 4 }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 81 }
    it { should_not be_valid }
  end

  # Email tests
  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when email format is not correct" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. @foo.com @]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is correct" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn a@b.c]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # Phone tests
  describe "when phone is not present" do
    before { @user.phone = "" }
    it { should_not be_valid }
  end

  describe "when phone is too short" do
    before { @user.phone = "1" * 8 }
    it { should_not be_valid }
  end

  describe "when phone is too long" do
    before { @user.phone = "1" * 21 }
    it { should_not be_valid }
  end

  # Password tests
  describe "when password is not present" do
    before { @user.password = "" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "a" * 5 }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "a" * 17 }
    it { should_not be_valid }
  end
end