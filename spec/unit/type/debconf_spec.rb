require 'spec_helper'

describe Puppet::Type.type(:debconf) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'when validating attributes' do
        [:item, :package, :type].each do |param|
          it "has a #{param} parameter" do
            expect(described_class.attrtype(param)).to eq(:param)
          end
        end
        [:value].each do |prop|
          it "has a #{prop} property" do
            expect(described_class.attrtype(prop)).to eq(:property)
          end
        end
      end

      describe 'namevar validation' do
        it 'has :item as its namevar' do
          expect(described_class.key_attributes).to eq([:item])
        end
      end
    end
  end
end
