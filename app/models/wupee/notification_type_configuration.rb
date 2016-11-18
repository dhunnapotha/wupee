class Wupee::NotificationTypeConfiguration < ActiveRecord::Base
  belongs_to :receiver, polymorphic: true
  belongs_to :notification_type, class_name: "Wupee::NotificationType"

  validates :notification_type, uniqueness: { scope: [:receiver] }
  validates :receiver, :notification_type, presence: true

  enum value: { both: 0, nothing: 1, email: 2, notification: 3 }

  DEFAULT_VALUE = 'both'


  def self.set_default_config(config = {})
    @@config = config
  end

  def self.get_default_config
    @@config ||= {}
  end

  def self.get_config_for(receiver, notification_name)
    receiver_config = get_default_config[receiver]
    return DEFAULT_VALUE unless receiver_config
    receiver_config[notification_name] || DEFAULT_VALUE
  end

  def wants_email?
    ['both', 'email'].include?(value)
  end

  def wants_notification?
    ['both', 'notification'].include?(value)
  end
end
