require 'spec_helper'

module Invent
  RSpec.describe WorkplaceCountPolicy do
    let(:manager) { create(:kucherenko_user) }
    let(:worker) { create(:shatunova_user) }
    let(:read_only) { create(:tyulyakova_user) }
    let(:lk_user) { create(:bayburin_user) }
    subject { WorkplaceCountPolicy }

    permissions :generate_pdf? do
      let!(:workplace_count) { create(:active_workplace_count, users: [lk_user]) }

      context 'with :lk_user role' do
        context 'and with valid user' do
          it 'grants access to the workplace_count' do
            expect(subject).to permit(lk_user, WorkplaceCount.find(workplace_count.workplace_count_id))
          end
        end

        context 'and with invalid user' do
          let(:another_user) { create(:user, role: lk_user.role) }

          it 'denies access to the workplace_count' do
            expect(subject).not_to permit(another_user, WorkplaceCount.find(workplace_count.workplace_count_id))
          end
        end
      end

      ['manager', 'worker', 'read_only'].each do |user|
        context "with #{user} role" do
          it 'grants access to the workplace_count' do
            expect(subject).to permit(send(user), WorkplaceCount.find(workplace_count.workplace_count_id))
          end
        end
      end
    end
  end
end
