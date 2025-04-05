require "rails_helper"

RSpec.describe PasswordResetTokenService do
  let(:user) { create(:user, reset_password_token: nil, reset_password_sent_at: nil) }

  describe ".call" do
    subject { described_class.new(email).call }

    context "when user email exists in system" do
      let (:email) { user.email }

      it "creates a secure random password reset token" do
        expect { subject }.to change { user.reload.reset_password_token }.from(nil)
        expect(user.reset_password_token).to be_present
      end

      it "updates reset_password_sent_at timestamp" do
        expect { subject }.to change { user.reload.reset_password_sent_at }.from(nil)
      end

      it "sends a reset password email" do
        expect { subject }.to have_enqueued_mail(PasswordMailer, :reset_password_email).with(including(params: including(user: user)))
      end

      it "returns :success response status" do
        expect(subject).to eq(:success)
      end
    end

    context "when user email does not exist" do
      let(:email) { "iamnotheremate@example.com" }

      it "does not create a token" do
        expect { subject }.not_to change { user.reload.reset_password_token }
      end

      it "returns :user_not_found response status" do
        expect(subject).to eq(:user_not_found)
      end
    end

    context "when saving the token fails for another reason" do
      let(:email) { user.email }

      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
      end

      it "does not send an email" do
        expect { subject }.not_to have_enqueued_mail(PasswordMailer, :reset_password_email)
      end

      it "does not create a token" do
        expect { subject }.not_to change { user.reload.reset_password_token }
      end

      it "returns :error_saving_token response status" do
        expect(subject).to eq(:error_saving_token)
      end
    end
  end
end
