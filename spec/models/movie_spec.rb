require 'rails_helper'

RSpec.describe Movie, type: :model do
  context "query movies of the same direcotr as a given movie" do
    it "return a movie list of that director if director not nil" do
      m1 = Movie.create({title:"t1", director:"d1"})
      m2 = Movie.create({title:"t2", director:"d1"})
      m3 = Movie.create({title:"t3", director:"d3"})
      expect(m1.similar).to eq([m1, m2])
    end
    it "return nil if director is nil" do
      m3 = Movie.create({title:"t3", director:"d3"})
      m4 = Movie.create({title:"t4", director:nil})
      expect(m4.similar).to be_nil
    end
  end
end
