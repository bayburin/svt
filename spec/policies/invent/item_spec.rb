require 'spec_helper'

module Invent
  RSpec.describe ItemPolicy do
    let(:manager) { create(:kucherenko_user) }
    let(:worker) { create(:shatunova_user) }
    let(:read_only) { create(:tyulyakova_user) }
    before { create(:used_item) }
    subject { ItemPolicy }

    permissions :destroy? do
      let(:model) { Item.first }

      include_examples 'policy for worker'
    end
  end
end
