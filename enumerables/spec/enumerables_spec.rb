require "./enumerables"

	
describe Enumerable do
	let(:numbers) { [1, 2, 3, 4, 5] }
	let(:things) { ["potatoes", "sofas", "nickels", "foxes"] }


	describe "#my_each" do
		context "when no block is passed" do
			it "returns enumerator" do
				expect(numbers.my_each).to be_an Enumerator
			end
		end

		context "when block is passed" do
			it "returns original numbers" do
				expect(numbers.my_each { |x| x }).to eql(numbers)
			end
		end
	end

	describe "#my_select" do 
		context "when no block is passed" do
			it "returns enumerator" do
				expect(numbers.my_select).to be_an Enumerator
			end
		end

		context "when passed block { |x| x > 3 }" do
			it "returns only numbers greater than 3" do
				expect(numbers.my_select { |x| x > 3 }).to eql([4, 5])
			end
		end

		context "when passed block { |x| x.include?('a') }" do
			it "returns only words with 'a'" do
				expect(things.my_select { |x| x.include?('a') }).to eql(["potatoes", "sofas"])
			end
		end 

	end

	describe "#my_any?" do
		context "when no block is passed" do
			it "returns true" do
				expect(numbers.my_any?).to eql(true)
			end
		end

		context "when passed block { |x| x > 6 }" do
			it "returns false" do
				expect(numbers.my_any? { |x| x > 6 }).to eql(false)
			end
		end

		context "when passed block { |x| x.include?('o')" do
			it "returns true" do
				expect(things.my_any? { |x| x.include?('o') }).to eql(true)
			end
		end
	end

	describe "#my_none?" do
		context "when passed no block" do
			it "returns true" do
				expect(numbers.my_none?).to eql(false)
			end
		end

		context "when passed block { |x| x > 10 }" do
			it "returns true" do
				expect(numbers.my_none? { |x| x > 10 }).to eql(true)
			end
		end

	end

	describe "#my_count" do
		context "when passed no block" do
			it "returns size of self" do
				expect(things.my_count).to eql(things.size)
			end
		end

		context "when passed block { |x| x == 3 }" do
			it "returns number of items equal to 3" do
				expect(numbers.my_count { |x| x == 3 }).to eql(1)
			end
		end
	end

	describe "#my_map" do
		context "when passed no block" do
			it "returns enumerator" do
				expect(things.my_map).to be_an Enumerator
			end
		end

		context "when passed block { |x| x + 3 }" do
			it "returns new array" do
				expect(numbers.my_map { |x| x + 3 }).to eql([4, 5, 6, 7, 8])
			end
		end
	end
end


