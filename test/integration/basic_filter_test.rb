require 'test_helper'

class BasicFilterController < ApplicationController
  filter_collection :by_key

  def index
    apply_scopes!

    render_results
  end

  def collection
    @collection ||= User.scoped
  end

  def by_key
    collection.where :key => params[:keys]
  end
end

class BasicFilterTest < ActionDispatch::IntegrationTest
  def test_a_basic_filter
    User.create! :key => 1
    User.create! :key => 2
    User.create! :key => 3
    User.create! :key => 4

    get '/basic_filter/index', :keys => %w(1 2 3)

    assert_response :success

    keys = JSON.parse response.body
    assert_equal %w(1 2 3), keys
  end
end
