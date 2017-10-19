require 'rails_helper'

module Invent
  RSpec.describe LkInventsController, type: :controller do
    # sign_in_through_lk_user
    let(:lk_user) { create :user }
    let!(:workplace_count) { create :active_workplace_count, users: [lk_user] }
    let(:lk_auth) { LkInvents::LkAuthorization.new('sid') }
    before do
      allow(LkInvents::LkAuthorization).to receive(:new).and_return(lk_auth)
      allow(lk_auth).to receive(:run).and_return(true)
      allow(lk_auth).to receive(:data).and_return(lk_user)
    end

    describe 'GET #svt_access' do
      it 'creates instance of the LkInvents::SvtAccess' do
        get :svt_access, params: { tn: 17664 }
        expect(assigns(:svt_access)).to be_instance_of LkInvents::SvtAccess
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::SvtAccess).to receive(:run)
        get :svt_access, params: { tn: 17664 }
      end
    end

    describe 'GET #init_properties' do
      it 'creates instance of the LkInvents::InitProperties' do
        get :init_properties
        expect(assigns(:properties)).to be_instance_of LkInvents::InitProperties
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::InitProperties).to receive(:run)
        get :init_properties
      end
    end

    describe 'GET #show_division_data' do
      it 'creates instance of the LkInvents::ShowDivisionData' do
        get :show_division_data, params: { division: workplace_count.division }
        expect(assigns(:division)).to be_instance_of LkInvents::ShowDivisionData
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::ShowDivisionData).to receive(:run)
        get :show_division_data, params: { division: workplace_count.division }
      end
    end

    describe 'GET #pc_config_from_audit' do
      it 'creates instance of the LkInvents::PcConfigFromAudit' do
        get :pc_config_from_audit, params: { invent_num: 111_222 }
        expect(assigns(:pc_config)).to be_instance_of LkInvents::PcConfigFromAudit
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::PcConfigFromAudit).to receive(:run)
        get :pc_config_from_audit, params: { invent_num: 111_222 }
      end
    end

    describe 'GET #pc_config_from_user' do
      let(:file) do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'old_pc_config.txt'), 'text/plain')
      end

      # it 'creates instance of the LkInvents::PcConfigFromUser' do
      #   get :pc_config_from_user, params: { pc_file: file }
      #   expect(assigns(:pc_file)).to be_instance_of LkInvents::PcConfigFromUser
      # end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::PcConfigFromUser).to receive(:run)
        post :pc_config_from_user, params: { pc_file: file }
      end
    end

    describe 'POST #create_workplace' do
      let(:workplace) do
        build :workplace_pk, :add_items, items: %i[pc monitor], workplace_count: workplace_count
      end
      let(:file) do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'old_pc_config.txt'), 'text/plain')
      end
      let(:wp_params) do
        {
          workplace: workplace.to_json,
          pc_file: file
        }
      end

      it 'creates instance of the LkInvents::CreateWorkplace' do
        post :create_workplace, params: wp_params
        expect(assigns(:workplace)).to be_instance_of LkInvents::CreateWorkplace
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::CreateWorkplace).to receive(:run)
        post :create_workplace, params: wp_params
      end
    end

    describe 'GET #edit_workplace' do
      let!(:workplace) do
        create :workplace_pk, :add_items, items: %i[pc monitor], workplace_count: workplace_count
      end

      it 'creates instance of the LkInvents::EditWorkplace' do
        get :edit_workplace, params: { workplace_id: workplace.workplace_id }
        expect(assigns(:workplace)).to be_instance_of LkInvents::EditWorkplace
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::EditWorkplace).to receive(:run)
        get :edit_workplace, params: { workplace_id: workplace.workplace_id }
      end
    end

    describe 'PUT #update_workplace' do
      let!(:workplace) do
        create :workplace_pk, :add_items, items: %i[pc monitor], workplace_count: workplace_count
      end
      let(:file) do
        Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'old_pc_config.txt'), 'text/plain')
      end
      let(:wp_params) do
        {
          workplace_id: workplace.workplace_id,
          workplace: workplace.to_json,
          pc_file: file
        }
      end

      it 'creates instance of the LkInvents::UpdateWorkplace' do
        put :update_workplace, params: wp_params
        expect(assigns(:workplace)).to be_instance_of LkInvents::UpdateWorkplace
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::UpdateWorkplace).to receive(:run)
        put :update_workplace, params: wp_params
      end
    end

    describe 'DELETE #destroy_workplace' do
      let!(:workplace) do
        create(:workplace_pk, :add_items, items: %i[pc monitor], workplace_count: workplace_count)
      end

      it 'create instance of the LkInvents::DestroyWorkplace' do
        delete :destroy_workplace, params: { workplace_id: workplace.workplace_id }
        expect(assigns(:workplace)).to be_instance_of LkInvents::DestroyWorkplace
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::DestroyWorkplace).to receive(:run)
        delete :destroy_workplace, params: { workplace_id: workplace.workplace_id }
      end
    end

    describe 'GET #generate_pdf' do
      it 'create instance of the LkInvents::DivisionReport' do
        get :generate_pdf, params: { division: 714 }
        expect(assigns(:division_report)).to be_instance_of LkInvents::DivisionReport
      end

      it 'calls :run method' do
        expect_any_instance_of(LkInvents::DivisionReport).to receive(:run)
        get :generate_pdf, params: { division: 714 }
      end
    end

    # describe 'GET #send_pc_script'
  end
end
