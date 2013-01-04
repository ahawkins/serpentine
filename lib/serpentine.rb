module Serpentine
  class CollectionFilterCallback < Struct.new(:name, :options, :block) ; end

  module ControllerHelper
    extend ActiveSupport::Concern

    included do
      class_attribute :collection_filters
      self.collection_filters = []
    end

    module ClassMethods
      def filter_collection(*args, &block)
        options = args.extract_options!
        args.each do |arg|
          self.collection_filters += [CollectionFilterCallback.new(arg, options, block)]
        end
      end
    end

    def apply_scopes!
      self.class.collection_filters.each do |callback|
        if apply_scopes?(callback.options)
          self.collection = send callback.name
        end
      end
    end

    def apply_scopes?(options)
      apply_scope_if?(options[:if]) ||
      apply_scope_unless?(options[:unless]) ||
      !options[:if] && !options[:unless]
    end

    def apply_scope_if?(operator)
      operator && (operator.respond_to?(:call) ? operator.call(params) : send(operator))
    end

    def apply_scope_unless?(operator)
      operator && (operator.respond_to?(:call) ? !operator.call(params) : !send(operator))
    end

    def collection=(collection)
      @collection = collection
    end
  end
end

require "serpentine/railtie"
