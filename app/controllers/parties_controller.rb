class PartiesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { ParliamentHelper.parliament_request.party_index },
    show:              proc { |params| ParliamentHelper.parliament_request.party_by_id.set_url_params({ party_id: params[:party_id] }) },
    lookup:            proc { |params| ParliamentHelper.parliament_request.party_lookup.set_url_params({ property: params[:source], value: params[:id] }) },
    current:           proc { ParliamentHelper.parliament_request.party_current },
    letters:           proc { |params| ParliamentHelper.parliament_request.party_by_initial.set_url_params({ initial: params[:letter] }) },
    a_to_z:            proc { ParliamentHelper.parliament_request.party_a_to_z },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.party_by_substring.set_url_params({ substring: params[:letters] }) },

    # NOT IN THE ORIGINAL ROUTE MAP BUT IN NEW DATA API URL STRUCTURE??
    current_a_to_z:      proc { ParliamentHelper.parliament_request.party_current_a_to_z }
  }.freeze

  def index
    @parties, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def show
    @party = @request.get.first
  end

  def lookup
    @party = @request.get.first

    redirect_to party_path(@party.graph_id)
  end

  def current
    @parties = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Party'
    ).sort_by(:name)
  end

  def letters
    @parties, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z].call)
  end

  def lookup_by_letters
    @parties, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    return redirect_to party_path(@parties.first.graph_id) if @parties.size == 1

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
