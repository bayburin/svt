require 'spec_helper'

RSpec.describe ApplicationPolicy do
  let(:lk_user) { create(:bayburin_user) }
  let(:admin_user) { create(:user) }
  before { allow_any_instance_of(User).to receive(:presence_user_in_users_reference) }
  subject { ApplicationPolicy }

  permissions :authorization? do
    it 'grants access to any controller with :admin role' do
      expect(subject).to permit(admin_user)
    end

    it 'denies access to any controller except :lk_invents to user with :lk_user role' do
      expect(subject).not_to permit(lk_user)
    end
  end
end
