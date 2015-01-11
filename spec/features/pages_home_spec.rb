require 'rails_helper'

describe "car searching" do

  before do
    VCR.use_cassette('edmunds_makes_car_form') do
      visit '/'
    end
  end

  describe "Find by Parameters" do
    it "should have a select tag called 'Year'" do
      expect(page).to have_css("select#year")
    end
    it "should have a select tag called 'Make' which is disabled" do
      expect(page).to have_css("select#make[disabled=disabled]")
    end
    it "should have a select tag called 'Model' which is disabled" do
      expect(page).to have_css('select#model[disabled=disabled]')
    end
    it "should have a select tag called 'Trim' which is disabled" do
      expect(page).to have_css('select#trim[disabled=disabled]')
    end

    describe "selecting a year" do
      before do
        VCR.use_cassette('edmunds_makes_from_2004') do
          select "2004", from:"year"
        end
      end

      it "should enable the select tag 'Make' after selecting a year", js:true do
        expect(page).to_not have_css('select#make[disabled=disabled]')
      end
      it "should contain a list of selectables", js:true do
        # count is actually 47, but includes the "select year"
        expect(page).to have_selector('select#make option', count:48)
      end
    end

  end

  describe "lookup by VIN" do
    it "should have a 'Lookup Car by VIN' button" do
      expect(page).to have_css('input.btn[value="Lookup Car by VIN"]')
    end

    it "should have a text box to do lookup by VIN" do
      expect(page).to have_css('input#vin')
    end

    context "less than 17 characters in the VIN text box" do
      it "should have the button blocked out" do
        expect(page).to have_css('input.btn[disabled=disabled]')
      end
    end

    context "equal to 17 characters in the VIN text box" do
      it "should enable the button", js:true do
        fill_in "vin", with:"a"*17
        expect(page).to_not have_css('input.btn[disabled=disabled]')
      end
    end

  end

  after :each do |example|
    save_and_open_page unless example.exception.nil?
  end

end