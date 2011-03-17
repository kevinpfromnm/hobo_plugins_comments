class Comment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    body :text, :required
    timestamps
  end

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :owner, :class_name => "User", :creator => true

  has_many :content_reports, :as => :reportable

  named_scope :recent, lambda { |n| { :order => 'updated_at DESC', :limit => n } }

  set_default_order "created_at desc"

  # --- Permissions --- #


  def create_permitted?
    owner_is? acting_user and acting_user.submit_permitted?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? or content_reports.valid_reports.blank?
  end

  # other methods
  def shortened_body
    return body.slice(0,100) + "..." if body.length > 100
    body
  end
end
