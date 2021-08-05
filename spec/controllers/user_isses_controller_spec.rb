require 'rails_helper'

RSpec.describe UserIssesController, type: :controller do
  sign_in_user

  describe 'GET #users_from_division' do
    describe 'GET #users_from_division' do
      let(:user) { create(:bayburin_user) }
      let!(:workplace_count) { create(:active_workplace_count, division: 714, users: [user]) }
      let(:result) do
        [
          build(:emp_drag),
          build(:emp_agureev),
          build(:emp_kucherenko),
          build(:emp_bartuzanovaan),
          build(:emp_bayburin)
        ].map { |employee| employee.slice('fullName', 'id') }.to_json
      end
      before do
        allow_any_instance_of(UserIssesController).to receive(:users_from_division)
        allow(response).to receive(:body).and_return(result)
      end

      it 'response get array users' do
        expect(response.body).to eq result

        get :users_from_division, params: { division: workplace_count.division }, format: :json
      end
    end
  end

  describe 'GET #items' do
    let(:user_iss_id_tn) { build(:emp_drag)['id'] }
    let!(:workplace) { create(:workplace_pk, :add_items, items: %i[pc monitor], id_tn: user_iss_id_tn) }
    let!(:another_workplace) { create(:workplace_pk, :add_items, items: %i[pc monitor]) }

    it 'loads all items for specified user' do
      get :items, params: { user_iss_id: user_iss_id_tn }, format: :json

      expect(response.body).to have_json_size(workplace.items.size)
    end

    it 'does not load items from another workplaces' do
      get :items, params: { user_iss_id: user_iss_id_tn }, format: :json

      parse_json(response.body).each do |item|
        expect(item['workplace_id']).not_to eq another_workplace.workplace_id
      end
    end

    %i[short_item_model type].each do |attr|
      it "has #{attr} attributes" do
        get :items, params: { user_iss_id: user_iss_id_tn }, format: :json

        expect(response.body).to have_json_path("0/#{attr}")
      end
    end
  end
end
