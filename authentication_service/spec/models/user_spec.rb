require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it('is valid with valid attributes') do
      user = build(:user)
      expect(user).to be_valid
    end
    it('is not valid without an email') do
      user = build(:user, email: '')
      expect(user).to_not be_valid
    end
    it('is not valid with a duplicate an email') do
      create(:user, email: 'duplicate@email.com')
      user = build(:user, email: 'duplicate@email.com')
      expect(user).to_not be_valid
    end
    it('is not valid when email does not match the format') do
      user = build(:user, email: 'invalid@emailcom')
      expect(user).to_not be_valid
    end
    it('is not valid when password_confirmation does not match the password') do
      user = build(:user, password_confirmation: 'wrong_password')
      expect(user).to_not be_valid
    end
    it('is not valid when password is too short') do
      user = build(:user, password: 'pass')
      expect(user).to_not be_valid
    end
  end

end
