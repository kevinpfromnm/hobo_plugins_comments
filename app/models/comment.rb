class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    body :text, :required
    timestamps
  end

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :owner, :class_name => "User", :creator => true

  named_scope :recent, lambda { |n| { :order => 'updated_at DESC', :limit => n } }

  set_default_order "created_at desc"

  # --- Permissions --- #


  def create_permitted?
    owner_is? acting_user
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
