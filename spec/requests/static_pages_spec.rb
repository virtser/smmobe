require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Welcome to SMMobe!') }
    it { should have_title("SMMobe - Smart Mobile Messages") }
    it { should_not have_title('| Home') }
  end
end