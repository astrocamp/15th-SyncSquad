# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  let(:event) { create(:event, company:) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_company).and_return(company)
  end

  describe 'GET index' do
    it 'assigns @events' do
      get :index
      expect(assigns(:events)).to eq(company.events.map(&:full_calendar_event))
    end
  end

  describe 'POST create' do
    context 'With valid attributes' do
      it 'Create a new event' do
        expect do
          post :create, params: { event: attributes_for(:event) }, format: :turbo_stream
        end.to change(Event, :count).by(1)
      end
    end

    context 'With invalid attributes' do
      it 'Create a new event but will fail' do
        expect do
          post :create, params: { event: attributes_for(:event, subject: nil) }
        end.not_to change(Event, :count)
      end
    end
  end

  describe 'PATCH update' do
    it 'Update the event' do
      patch :update, params: { id: event.id, event: { subject: 'New Subject' } }, format: :turbo_stream
      event.reload
      expect(event.subject).to eq('New Subject')
    end
  end

  describe 'DELETE destroy' do
    it 'Delete the event' do
      event
      expect do
        delete :destroy, params: { id: event.id }, format: :turbo_stream
      end.to change(Event, :count).by(-1)
    end
  end
end
