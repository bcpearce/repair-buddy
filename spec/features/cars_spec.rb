require 'rails_helper'

describe "cars" do

  #let(:user) { create(:user) }
  #let(:car1) { create(:car, make:"Honda", model:"Civic", year:2015, trim:"EX", user_id:user.id) }
  #let(:car2) { create(:car, make:"Acura", model:"TSX", year:2014, trim:"XL", user_id:user.id) }

  describe "the garage view (cars#index)" do
    before do
      @user = create(:user)
      @car1 = create(:car, make:"Acura", model:"TSX", year:2014, trim:"XL", user_id:@user.id)
      @car2 = create(:car, make:"Honda", model:"Civic", year:2015, trim:"EX", user_id:@user.id)

      login_as @user, scope: :user
      visit '/'
      click_link("Garage")
    end

    it "should have a link to the show page for each of the user's cars" do
      expect(page).to have_link("#{@car1.year} #{@car1.make} #{@car1.model}", href:user_car_path(@user.id, @car1.id))
      expect(page).to have_link("#{@car2.year} #{@car2.make} #{@car2.model}", href:user_car_path(@user.id, @car2.id))
    end
    it "should have a link to add a new record for each of the user's cars" do
      expect(page).to have_link("Add New Service Record", href:new_user_car_record_path(@user.id, @car1.id))
      expect(page).to have_link("Add New Service Record", href:new_user_car_record_path(@user.id, @car2.id))
    end
    it "should have a link to the record index for each of the user's cars" do
      expect(page).to have_link("Service Records", href:user_car_records_path(@user.id, @car1.id))
      expect(page).to have_link("Service Records", href:user_car_records_path(@user.id, @car2.id))
    end
    it "should have a link to remove each car from a user's garage" do
      expect(page).to have_link("Remove from Garage", href:user_car_path(@user.id, @car1.id))
      expect(page).to have_link("Remove from Garage", href:user_car_path(@user.id, @car2.id))
    end
    describe "deleting items" do
      before { within("#car1") { click_link("Remove from Garage") } }
      it "allows deleting of cars" do
        expect(@user.cars.count).to eq(1)
      end
      it "hides the item in the list" do
        expect(page).to_not have_content("#{@car1.year} #{@car1.make} #{@car1.model}")
        expect(page).to have_content("#{@car2.year} #{@car2.make} #{@car2.model}")
      end
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end
