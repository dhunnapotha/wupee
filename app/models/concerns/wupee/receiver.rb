module Wupee
  module Receiver
    extend ActiveSupport::Concern

    included do
      has_many :notifications, as: :receiver, dependent: :destroy, class_name: "Wupee::Notification"
      has_many :notification_type_configurations, as: :receiver, dependent: :destroy, class_name: "Wupee::NotificationTypeConfiguration"

      after_create do
        Wupee::NotificationType.select([:id, :name]).each do |notification|
          value = Wupee::NotificationTypeConfiguration.get_config_for(self.class.to_s, notification.name)
          Wupee::NotificationTypeConfiguration.create!(notification_type_id: notification.id, receiver: self, value: value)
        end
      end
    end
  end
end
