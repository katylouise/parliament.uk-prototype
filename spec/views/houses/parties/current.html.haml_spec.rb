require 'rails_helper'

RSpec.describe 'houses/parties/current', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:house, double(:house, name: 'House of Commons', graph_id: 'Kz7ncmrt'))
    @parties = [double(:party, name: 'Conservative', graph_id: '891w1b1k', member_count: 10)]

    render
  end

  context 'header' do
    it 'will render the current person type' do
      expect(rendered).to match(/Current parties/)
    end
  end

  context 'partials' do
    it 'will render party' do
      expect(response).to render_template(partial: 'houses/parties/_party')
    end

    it 'will render dissolution message' do
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end

  context 'links' do
    it 'will render tab link to house_parties_current_path' do
      expect(rendered).to have_link('Lords', href: house_parties_current_path('MvLURLV5'))
    end
  end
end
