require 'rails_helper'

describe Record, type: :model do
  context "meta is nil" do
    let(:subject) { described_class.create meta: nil }
    describe "getter" do
      it { expect(subject.field1).to eq nil }
      it { expect{ subject.field5 }.to raise_exception(NoMethodError) }
    end
    describe "setter" do
      it do
        subject.field1 = '123'
        expect(subject.meta).to eq({ "field1" => "123" })
        expect(subject.field1).to eq '123'
      end
    end
    context "scope" do
      describe "getter" do
        it { expect(subject.field2).to be_nil }
      end
      describe "setter" do
        it do
          subject.field2 = 'value3'
          expect(subject.field2).to eq "value3"
          expect(subject.field2_was).to be_nil
        end
        it "can be batch" do
          subject.scope1 = { 'field2' => 'value3' }
          expect(subject.field2).to eq "value3"
          expect(subject.field2_was).to be_nil
        end
      end
    end
  end
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
      it "strip spaces" do
        subject.field1 = '  abc  '
        expect(subject.field1).to eq 'abc'
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
        it do
          expect(subject.field1_change).to eq(['value1', '123'])
          expect(subject.changes).to eq({ 'field1' => ['value1', '123'] })
        end
      end
    end

    context "default value" do
    end
  end

  context "scope" do
    let(:subject) { described_class.create meta: { "field1" => "value1", "scope1" => { "field2" => "value2" } } }

    describe "getter" do
      it { expect(subject.field2).to eq 'value2' }
    end

    describe "setter" do
      it do
        subject.field2 = 'value3'
        expect(subject.field2).to eq "value3"
        expect(subject.field2_was).to eq "value2"
      end
      it "can be batch" do
        subject.scope1 = { 'field2' => 'value3' }
        expect(subject.field2).to eq "value3"
        expect(subject.field2_was).to eq "value2"
      end
    end
    it "tracks changes" do
      is_expected.not_to be_changed
      is_expected.not_to be_meta_changed
      is_expected.not_to be_field2_changed

      expect(subject.changes).to be_empty
      subject.field2 = '123'

      is_expected.to be_changed
      is_expected.to be_meta_changed
      is_expected.to be_field2_changed

      expect(subject.field2).to eq '123'
      expect(subject.field2_was).to eq 'value2'
      expect(subject.field2_change).to eq ['value2', '123']
      expect(subject.changed).to include 'meta'
      expect(subject.changed).not_to include 'scope1'
      expect(subject.changed).to include 'field2'
      expect(subject.changes).to eq({ 'field2' => ['value2', '123'] })
    end
  end
end
