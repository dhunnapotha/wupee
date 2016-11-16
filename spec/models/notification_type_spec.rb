require 'rails_helper'

RSpec.describe Wupee::NotificationType, type: :model do
  let!(:receiver) { create :user }
  let!(:notification_type_name) { 'notify_new_message' }
  let!(:notification_type) { create :notification_type, name: notification_type_name }
  let!(:notification) { create :notification, notification_type: notification_type, receiver: receiver }

  context "validations" do
    it "validates presence of name" do
      notification_type = Wupee::NotificationType.new
      notification_type.valid?
      expect(notification_type.errors).to have_key :name
    end

    it "validates presence of uniqueness of name" do
      notification_type = Wupee::NotificationType.new(name: notification_type_name)
      notification_type.valid?
      expect(notification_type.errors).to have_key :name
    end
  end

  context "methods" do
    it "responds to notification_type_configurations" do
      expect(notification_type).to respond_to(:notification_type_configurations)
    end

    it "responds to notifications" do
      expect(notification_type).to respond_to(:notifications)
    end
  end

  context "class methods" do
    context 'has a method create_configurations_for' do

      it "which creates NotificationTypeConfiguration objects" do
        expect { create :notification_type, name: "random_notif_type_2" }.to change { Wupee::NotificationTypeConfiguration.count }.by(User.count)
      end

      it 'creates configuration objects with default configs value' do
        expect(User.count).to eq(1)
        default_config = {
          'User' => {
            'signed_in' => 'notification'
          }
        }
        Wupee::NotificationTypeConfiguration.set_default_config default_config
        create :notification_type, name: "signed_in"
        expect(Wupee::NotificationTypeConfiguration.last.value).to eq('notification')
      end
    end


  end

  context "associations" do
    it "destroys notification_type_configurations on destroy" do
      expect { notification_type.destroy! }.to change { Wupee::Notification.count }.by(-1)
    end

    it "destroys notifications on destroy" do
      expect { notification_type.destroy! }.to change { Wupee::NotificationTypeConfiguration.count }.by(-1)
    end
  end
end
