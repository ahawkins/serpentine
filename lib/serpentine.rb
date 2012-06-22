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
        if callback.options[:if] && (callback.options[:if].respond_to?(:call) ? callback.options[:if].call(params) : send(options[:if]))
          self.collection = send callback.name
        elsif callback.options[:unless] && !(callback.options[:unless].respond_to?(:call) ? callback.options[:unless].call(params) : send(options[:unless]))
          self.collection = send callback.name
        elsif !callback.options[:if] && !callback.options[:unless]
          self.collection = send callback.name
        end
      end
    end
  end
end

require "serpentine/railtie"
