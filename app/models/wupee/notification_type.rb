class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy
  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy

  def self.create_configurations_for(*receivers)
    class_eval do
      receivers.each do |receiver|
        after_create do
          value = Wupee::NotificationTypeConfiguration.get_config_for(receiver, self.name)
          receiver.to_s.constantize.select(:id).find_each(batch_size: 5000) do |obj|
            Wupee::NotificationTypeConfiguration.create!(notification_type: self, receiver_type: receiver, receiver_id: obj.id, value: value)
          end
        end
      end
    end
  end
end
