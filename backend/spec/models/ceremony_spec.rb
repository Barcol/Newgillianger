require 'rails_helper'

RSpec.describe Ceremony, type: :model do
  subject {
    described_class.new(
      name: "Umbrela Opening",
      event_date: DateTime.now + 1.week
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a too long name" do
    subject.name = "a" * 256
    expect(subject).to_not be_valid
  end

  it "is not valid without an event_date" do
    subject.event_date = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a blank name" do
    subject.name = ""
    expect(subject).to_not be_valid
  end

  it "is not valid with an invalid event_date format" do
    subject.event_date = "invalid date"
    expect(subject).to_not be_valid
  end
end
