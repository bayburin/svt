shared_examples 'policy for worker' do
  %w[manager worker].each do |role_name|
    context "with #{role_name} role" do
      it 'grants access' do
        expect(subject).to permit(send(role_name), model)
      end
    end
  end

  context 'with :read_only role' do
    it 'denies access' do
      expect(subject).not_to permit(read_only, model)
    end
  end
end

shared_examples 'policy for manager' do
  context 'with :manager role' do
    it 'grants access' do
      expect(subject).to permit(manager, model)
    end
  end

  %w[worker read_only].each do |role_name|
    context "with #{role_name} role" do
      it 'denies access' do
        expect(subject).not_to permit(send(role_name), model)
      end
    end
  end
end

shared_examples 'policy not for lk_user' do
  context 'with :lk_user role' do
    it 'denies access' do
      expect(subject).not_to permit(lk_user, model)
    end
  end

  %w[manager worker read_only].each do |role_name|
    context "with #{role_name} role" do
      it 'allows access' do
        expect(subject).to permit(send(role_name), model)
      end
    end
  end
end
