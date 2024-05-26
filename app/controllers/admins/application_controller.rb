class Admins::ApplicationController < ApplicationController
  before_action :authenticate_administrator!

  layout 'admins'
end
