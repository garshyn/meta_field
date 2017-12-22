require 'rails_helper'

describe Record, type: :model do
  context "regular usage" do
    let(:subject) { described_class.create meta: { "field1" => "value1" } }
    it "shows the data as it is stored" do
      expect(subject.meta).to eq({ "field1" => "value1" })
    end

    describe "getter" do
      it { expect(subject.field1).to eq 'value1' }
    end

    describe "setter" do
      it do
        subject.field1 = '123'
        expect(subject.meta).to eq({ "field1" => "123" })
        expect(subject.field1).to eq '123'
      end
    end

    describe "tracking changes" do
      before :each do
        subject.field1 = '123'
      end
      it { expect(subject.field1).to eq '123' }
      it { expect(subject.field1_was).to eq 'value1' }

      it "returns change array" do
        expect(subject.field1_change).to eq ['value1', '123']
      end

    end

    describe ".changed?" do
      it { is_expected.not_to be_changed }
      it { is_expected.not_to be_meta_changed }
      it { is_expected.not_to be_field1_changed }
      context "after change" do
        before :each do
          subject.field1 = '123'
        end
        it { is_expected.to be_changed }
        it { is_expected.to be_meta_changed }
        it { is_expected.to be_field1_changed }
      end
    end

    describe ".changes" do
      it { expect(subject.changes).to be_empty }
      context "after change" do
        before :each do
          subject.field1 = '123'
        end
        it { expect(subject.changes.keys).not_to include 'meta' }
        it { expect(subject.changes.keys).to include 'field1' }
        it { expect(subject.changes).to eq({ 'field1' => ['value1', '123'] }) }
      end
    end

    # context "scoped fields" do
    #   let(:subject) { described_class.create meta: { "field1" => "value1", "some_scope" => { "field2" => "value2" } } }
    #   it do
    #     subject.some_scope = { 'field2' => 'value3' }
    #     # subject.field2 = 'value3'
    #     expect(subject.field2).to eq "value3"
    #     expect(subject.field2_was).to eq "value2"
    #   end
    # end

    context "default value" do
    end
  end

  context "scope" do
  end

  context "scope with prefix" do
  end
end
