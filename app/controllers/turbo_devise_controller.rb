<<<<<<< HEAD
# frozen_string_literal: true

class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

=======
class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    # 重寫了 to_turbo_stream 方法
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
      # 當沒有辦法找到對應的 view
    rescue ActionView::MissingTemplate => e
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

>>>>>>> 7b5e036 (rubocop)
  self.responder = Responder
  respond_to :html, :turbo_stream
end
