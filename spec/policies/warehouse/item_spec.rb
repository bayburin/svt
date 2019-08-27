require 'spec_helper'

module Warehouse
  RSpec.describe ItemPolicy do
    let(:lk_user) { create(:bayburin_user) }
    let(:manager) { create(:kucherenko_user) }
    let(:worker) { create(:shatunova_user) }
    let(:read_only) { create(:tyulyakova_user) }
    before { create(:used_item) }
    subject { ItemPolicy }

    permissions :ctrl_access? do
      let(:model) { Item.first }

      include_examples 'policy not for lk_user'
    end

    permissions :destroy? do
      let(:model) { Item.first }

      include_examples 'policy for worker'
    end

    permissions :update? do
      let(:model) { create(:new_item) }

      include_examples 'policy for worker'
      include_examples 'status for item is non_used'
    end

    permissions :edit? do
      let(:model) { create(:new_item) }

      include_examples 'status for item is non_used'
    end
  end
end
