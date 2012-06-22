require 'test_helper'

class MultipleFiltersController < ApplicationController
  filter_collection :by_key
  filter_collection :to_nil

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

  def to_nil
    collection.where :key => nil
  end
end

class MultipleFilterTest < ActionDispatch::IntegrationTest
  def test_multiple_filters_applied
    User.create! :key => 1
    User.create! :key => 2
    User.create! :key => 3
    User.create! :key => 4

    get '/multiple_filters/index', :keys => %w(1 2 3)

    assert_response :success

    keys = JSON.parse response.body
    assert_equal [], keys
  end
end
