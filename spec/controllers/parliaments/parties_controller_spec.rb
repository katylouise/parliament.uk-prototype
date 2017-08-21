require 'rails_helper'

RSpec.describe Parliaments::PartiesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: 'fHx6P1lb' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context '@parliament' do
      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end
    end

    context '@parties' do
      it 'assigns @parties' do
        assigns(:parties).each do |party|
          expect(party).to be_a(Grom::Node)
          expect(party.type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'assigns @parties in member count then name order' do
        expect(assigns(:parties)[0].name).to eq('partyName - 2')
        expect(assigns(:parties)[0].member_count).to eq(309)
        expect(assigns(:parties)[1].name).to eq('partyName - 14')
        expect(assigns(:parties)[1].member_count).to eq(273)
        expect(assigns(:parties)[10].name).to eq('partyName - 10')
        expect(assigns(:parties)[10].member_count).to eq(1)
        expect(assigns(:parties)[11].name).to eq('partyName - 12')
        expect(assigns(:parties)[11].member_count).to eq(1)
        expect(assigns(:parties)[12].name).to eq('partyName - 5')
        expect(assigns(:parties)[12].member_count).to eq(1)
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    context '@party is nil' do
      # updated VCR cassette in order to set @party to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :show, params: { parliament_id: 'fHx6P1lb', party_id: '891w1b1k' }}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@party is not nil' do
      before(:each) do
        get :show, params: { parliament_id: 'fHx6P1lb', party_id: '891w1b1k' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      context '@parliament' do
        it 'assigns @parliament' do
          expect(assigns(:parliament)).to be_a(Grom::Node)
          expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
        end
      end

      context '@party' do
        it 'assigns @party' do
          expect(assigns(:party)).to be_a(Grom::Node)
          expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'renders the party template' do
        expect(response).to render_template('show')
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { parliament_id: 'fHx6P1lb' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_parties?parliament_id=fHx6P1lb"
          },
          {
            route: 'show',
            parameters: { parliament_id: 'fHx6P1lb', party_id: '891w1b1k' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliament_party?parliament_id=fHx6P1lb&party_id=891w1b1k"
          }
        ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        methods.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end
  end
end
