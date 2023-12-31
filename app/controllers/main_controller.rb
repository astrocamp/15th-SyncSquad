# frozen_string_literal: true

class MainController < ApplicationController
  def home
    @company = Company.new
  end
end
