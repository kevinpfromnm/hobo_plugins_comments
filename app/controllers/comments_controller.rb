class CommentsController < ApplicationController

  hobo_model_controller

  auto_actions :create, :destroy

end
