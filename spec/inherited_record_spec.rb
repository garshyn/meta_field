require 'rails_helper'

describe InheritedRecord, type: :model do
  let(:subject) { described_class.create meta: { "field1" => "value1", "field5" => "value3" } }

  it "shows the data as it is stored" do
    expect(subject.meta).to eq({ "field1" => "value1", "field5" => "value3" })
  end

  it "can have default value" do
    expect(described_class.new.field5).to eq 0
  end

  describe "getter" do
    it { expect(subject.field1).to eq 'value1' }
    it { expect(subject.field5).to eq 'value3' }
  end

  describe "setter" do
    it do
      subject.field5 = '123'
      expect(subject.field5).to eq '123'
    end
  end


end
