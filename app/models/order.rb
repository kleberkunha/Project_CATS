class Order < ApplicationRecord
  belongs_to :user
  has_many :items, through: :cart_lines

  after_create :admin_confirmation

  def after_order_send
    UserMailer.after_order_email(self).deliver_now
  end

  def admin_confirmation
    UserMailer.admin_confirmation(self).deliver_now
  end
end
