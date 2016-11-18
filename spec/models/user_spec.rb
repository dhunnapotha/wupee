require 'rails_helper'
require_relative './concerns/receiver_spec'

RSpec.describe User, type: :model do
  it_behaves_like "Wupee::Receiver"
end
