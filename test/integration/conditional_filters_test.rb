require 'test_helper'

class IfFilterController < ApplicationController
  filter_collection :by_key, :if => proc { |params| params[:monkey] }

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

class IfFilterTest < ActionDispatch::IntegrationTest
  def test_an_if_conditional
    User.create! :key => 1
    User.create! :key => 2
    User.create! :key => 3
    User.create! :key => 4

    get '/if_filter/index', :keys => %w(1 2 3), :monkey => true

    assert_response :success

    keys = JSON.parse response.body
    assert_equal %w(1 2 3), keys
  end
end

class UnlessFilterController < ApplicationController
  filter_collection :by_key, :unless => proc { |params| params[:monkey] }

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

class UnlessFilterTest < ActionDispatch::IntegrationTest
  def test_an_unless_conditional
    User.create! :key => 1
    User.create! :key => 2
    User.create! :key => 3
    User.create! :key => 4

    get '/unless_filter/index', :keys => %w(1 2 3), :monkey => true

    assert_response :success

    keys = JSON.parse response.body
    assert_equal %w(1 2 3 4), keys
  end
end
