require 'rails_helper'

RSpec.describe User, type: :model do
    it 'is valid with a email, name, password, and password_confirmation' do
        user = User.new(email: 'testmail@example.com', name: 'Test User', password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
    end

    it 'is invalid without a email' do
        user = User.new(email: nil, name: 'Test User', password: 'password', password_confirmation: 'password')
        expect(user).to_not be_valid
    end

    it 'is invalid without a name' do
        user = User.new(email: 'testmail@example.com', name: nil, password: 'password', password_confirmation: 'password')
        expect(user).to_not be_valid
    end

    it 'is invalid without a password' do
        user = User.new(email: 'testmail@example.com', name: 'Test User', password: nil, password_confirmation: 'password')
        expect(user).to_not be_valid
    end
end