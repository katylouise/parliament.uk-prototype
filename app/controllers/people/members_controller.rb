module People
  class MembersController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      index:           proc { ParliamentHelper.parliament_request.member_index },
      current:         proc { ParliamentHelper.parliament_request.member_current },
      letters:         proc { |params| ParliamentHelper.parliament_request.member_by_initial.set_url_params({ initial: params[:letter] }) },
      current_letters: proc { |params| ParliamentHelper.parliament_request.member_current_by_initial.set_url_params({ initial: params[:letter] }) },
      a_to_z:          proc { ParliamentHelper.parliament_request.member_a_to_z },
      a_to_z_current:  proc { ParliamentHelper.parliament_request.member_current_a_to_z }
    }.freeze

    def index
      @people, @letters = RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current
      @people, @letters = RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def letters
      @people, @letters = RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current_letters
      @people, @letters = RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def a_to_z
      @letters = RequestHelper.process_available_letters(@request)
    end

    def a_to_z_current
      @letters = RequestHelper.process_available_letters(@request)
    end
  end
end
