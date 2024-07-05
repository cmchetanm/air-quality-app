RSpec.describe AirPollutionHistory, type: :model do
  
  describe "associations" do
    it { should belong_to(:location) }
  end
end