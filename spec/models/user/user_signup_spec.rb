require 'spec_helper'

describe User do

  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }
  it { should respond_to(:password) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  # Name tests
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
      duplicated_user_with_same_email = @user.dup
      duplicated_user_with_same_email.email = @user.email
      duplicated_user_with_same_email.save
      it { should_not be_valid }
    end
  end

  # Phone tests
  describe "when phone is too short" do
    before { @user.phone = "1" * 8 }
    it { should_not be_valid }
  end

  describe "when phone is too long" do
    before { @user.phone = "1" * 21 }
    it { should_not be_valid }
  end

  # Password tests
  describe "when password is too short" do
    before { @user.password = "a" * 5 }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "a" * 17 }
    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      #specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # User creation test
  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create User" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: @user.name
        fill_in "Email",        with: @user.email + 'a' # just to make it unique again
        fill_in "Phone",        with: @user.phone
        fill_in "Password",     with: @user.password
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

  # Token creation test
  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).not_to be_blank }
  end



end