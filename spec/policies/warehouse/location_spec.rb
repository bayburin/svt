require 'spec_helper'

module Warehouse
  RSpec.describe LocationPolicy do
    let(:lk_user) { create(:bayburin_user) }
    let(:manager) { create(:kucherenko_user) }
    let(:worker) { create(:shatunova_user) }
    let(:read_only) { create(:tyulyakova_user) }
    before { create(:used_item) }
    subject { LocationPolicy }

    permissions :ctrl_access? do
      let(:model) { Item.first }

      include_examples 'policy not for lk_user'
    end
  end
end
