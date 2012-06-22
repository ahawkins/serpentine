module Serpentine
  class Railtie < ::Rails::Railtie
    initializer "serpentine.application_controller" do
      ActiveSupport.on_load(:action_controller) do
        include ControllerHelper
      end
    end
  end
end
