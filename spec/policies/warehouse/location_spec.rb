require 'spec_helper'

module Warehouse
  RSpec.describe LocationPolicy do
    let(:lk_user) { create(:bayburin_user) }
    let(:manager) { create(:kucherenko_user) }
    let(:worker) { create(:shatunova_user) }
    let(:read_only) { create(:tyulyakova_user) }
    before do
      allow_any_instance_of(User).to receive(:presence_user_in_users_reference)
      create(:used_item)
    end
    subject { LocationPolicy }

    permissions :ctrl_access? do
      let(:model) { Item.first }

      include_examples 'policy not for lk_user'
    end
  end
end
