class Wupee::NotificationType < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :notification_type_configurations, foreign_key: :notification_type_id, dependent: :destroy
  has_many :notifications, foreign_key: :notification_type_id, dependent: :destroy

  def self.create_configurations_for(*receivers)
    class_eval do
      receivers.each do |receiver|
        after_create do
          receiver.to_s.constantize.select(:id).find_in_batches(batch_size: 5000) do |receivers_batch|
            configurations = []
            receivers_batch.each do |receiver_object|
              configurations << { notification_type: self, receiver_type: receiver, receiver_id: receiver_object.id }
            end

            Wupee::NotificationTypeConfiguration.create! configurations
          end
        end
      end
    end
  end
end
