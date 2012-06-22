# Serpentine

Serpentine makes complicated query parameters easy. This is a very
commong problem in rails applications. Your controller needs to accept a
variety of input parameters to filter/order/search a collection in some
way. It's not hard to write this logic, but **god damn** it is a pain in
the ass. It's just a lot of worthless conditional programming.
Serpentine makes this easier.

## Usage

```ruby
class PostsController < ApplicationController
  filter_collection :alphabetically
  filter_collection :by_ids, :if => proc { |params| params[:ids] }

  # apply_filters! is added by Serpentine. You can call it yourself
  # in your own actions if you like.
  before_filter :apply_filters!, :only => :index

  # define a collection accessor
  # It is important to use ||= here
  # otherwise Post.unscoped will *always* be passed into
  # the next filter
  def collection
    @collection ||= Post.unscoped
  end

  def index
    respond_with @collection
  end

  private

  # define methods declared in filters
  def alphabetically
    collection.alphabetically
  end

  def by_ids
    collection.where :id => params[:ids]
  end
end
```

## More Examples
```ruby
class PostsController < ApplicationController
  filter_collection :method_name, :if => proc { |params| }
  filter_collection :method_name, :if => :name_of_method
  filter_collection :method_name, :unless => proc { |params| }
  filter_collection :method_name, :unless => :name_of_method
  filter_collection :method_name

  def collection
    @collection ||= Post.unscoped
  end

  def index
    apply_scopes!

    # collection now has all the different filters applied

    do_more_logic_on collection

    respond_with collection
  end
end
```

And that's it! This will keep the real logic outside of your actions.
This make it trivially easy to add more filters. Filters are
inheritable. You can define filters in `ApplicationController` and they
will be passed down to all other subclasses.
