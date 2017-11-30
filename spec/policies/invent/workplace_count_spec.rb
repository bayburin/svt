require 'spec_helper'

module Invent
  RSpec.describe WorkplaceCountPolicy do
    subject { WorkplaceCountPolicy }

    permissions :generate_pdf? do
      let(:bayburin_user) { create(:bayburin_user) }
      let!(:workplace_count) { create(:active_workplace_count, users: [bayburin_user]) }

      context 'with :lk_user role' do
        context 'with valid user' do
          it 'allows access to the workplace_count' do
            expect(subject).to permit(bayburin_user, WorkplaceCount.find(workplace_count.workplace_count_id))
          end
        end

        context 'with invalid user' do
          let(:another_user) { create(:user, role: bayburin_user.role) }

          it 'denies access to the workplace_count' do
            expect(subject).not_to permit(another_user, WorkplaceCount.find(workplace_count.workplace_count_id))
          end
        end
      end

      context 'with :manager role' do
        let(:admin_user) { create(:user) }

        it 'allows access to the workplace_count' do
          expect(subject).to permit(admin_user, WorkplaceCount.find(workplace_count.workplace_count_id))
        end
      end
    end
  end
end
