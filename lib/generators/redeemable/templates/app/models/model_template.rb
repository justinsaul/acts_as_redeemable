class <%= class_name %> < ActiveRecord::Base
  acts_as_redeemable<%= " :multi_use => true" if redemption_class_name %>

  belongs_to :user  
<% if redemption_class_name -%>
  has_many :redemptions, :class_name => "<%= redemption_class_name %>"
  has_many :redeemers, :through => :redemptions, :source => :user
<% else -%>
  belongs_to :redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"
<% end -%>

  validates_presence_of :user_id
end
