module Inventory
  shared_examples 'workplace policy with :lk_user role' do
    context 'when :lk_user role' do
      context 'with valid user, in allowed time, when workplace status is not confirmed' do
        it 'allows access to the workplace' do
          expect(subject).to permit(bayburin_user, Workplace.find(workplace.workplace_id))
        end
      end

      context 'with invalid user' do
        let(:another_user) { create :user, role: bayburin_user.role }

        it 'denies access to the workplace' do
          expect(subject).not_to permit(another_user, Workplace.find(workplace.workplace_id))
        end
      end

      context 'when out of allowed time' do
        let(:workplace_count) { create :inactive_workplace_count, users: [bayburin_user] }

        it 'denies access to the workplace' do
          expect(subject).not_to permit(bayburin_user, Workplace.find(workplace.workplace_id))
        end
      end

      context 'when workplace status is confirmed' do
        let(:workplace) do
          create :workplace_mob, :add_items, items: %i[tablet], workplace_count: workplace_count, status: 'confirmed'
        end

        it 'denies access to the workplace' do
          expect(subject).not_to permit(bayburin_user, Workplace.find(workplace.workplace_id))
        end
      end
    end
  end
end