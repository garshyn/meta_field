require 'rails_helper'

describe OtherRecord, type: :model do
  let(:subject) { described_class.create meta: { "field3" => "value1", "field4" => "value3" } }

  it "shows the data as it is stored" do
    expect(subject.meta).to eq({ "field3" => "value1", "field4" => "value3" })
  end

  it "can have default value" do
    expect(described_class.new.field3).to eq 1
    expect(described_class.new.field4).to eq 1
  end

  describe "getter" do
    it { expect{ subject.field1 }.to raise_exception(NoMethodError) }
    it { expect{ subject.field2 }.to raise_exception(NoMethodError) }
    it { expect(subject.field3).to eq 'value1' }
    it { expect(subject.field4).to eq 'value3' }
    it { expect{ subject.field5 }.to raise_exception(NoMethodError) }
  end

  describe "setter" do
    it do
      subject.field4 = '123'
      expect(subject.field4).to eq '123'
    end
  end


end
