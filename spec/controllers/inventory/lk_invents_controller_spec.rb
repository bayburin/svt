require 'rails_helper'

module Inventory
  RSpec.describe LkInventsController, type: :controller do
    let(:user) { create :lk_user }
    before { sign_in(user, scope: :user) }
    before { controller.class.skip_before_action :check_lk_authorization }

    describe "#init" do
      context "when get request" do
        subject { get :init, params: { tn: 17664 } }
        before { subject }
        let(:data) { JSON.parse(subject.body) }

          it "must have 'divisions' key" do
            expect(data).to have_key('divisions')
          end

        # it "response with json object" do
          # expect(data).to
        # end


        # context "when action responses" do
        #   let(:data) { JSON.parse(subject.body) }
        #
        #   it "must have 'divisions' key" do
        #     expect(data).to have_key('divisions')
        #   end
        # end
      end
    end
  end
end