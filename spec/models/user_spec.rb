require "rails_helper"

RSpec.describe User, type: :model do
  it "creates a non-admin user" do
    user = FactoryBot.create(:user)
    expect(user.email).to eq "testuser@email.com"
    expect(user.password).to eq "password"
    expect(user.user_info.admin).to eq false
  end

  it "creates an admin user" do
    user = FactoryBot.create(:user, :admin)
    expect(user.email).to eq "testadmin@email.com"
    expect(user.password).to eq "password"
    expect(user.user_info.admin).to eq true
  end

  it "has a valid user_info" do
    user = FactoryBot.create(:user)
    expect(user.user_info).to be_valid
    expect(user.user_info.user_id).to eq user.id
  end
end
