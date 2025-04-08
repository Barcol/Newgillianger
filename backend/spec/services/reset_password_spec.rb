require "rails_helper"

RSpec.describe ResetPasswordService do
  let(:user) { create(:user, reset_password_token: SecureRandom.hex(20), reset_password_sent_at: Time.current) }
  let(:token) { user.reset_password_token }

  describe ".call" do
    subject { described_class.new(token, password, password_confirmation).call }

    context "when token is valid and passwords match" do
      let(:password) { "newsecurepassword" }
      let(:password_confirmation) { "newsecurepassword" }

      it "resets the user's password" do
        expect { subject }.to change { user.reload.authenticate("newsecurepassword") }.from(false).to(user)
      end

      it "removes the reset token" do
        expect { subject }.to change { user.reload.reset_password_token }.to(nil)
      end

      it "returns :success" do
        expect(subject).to eq(:success)
      end
    end

    context "when token is invalid" do
      let(:token) { "invalidtoken" }
      let(:password) { "newsecurepassword" }
      let(:password_confirmation) { "newsecurepassword" }

      it "does not reset the password" do
        expect { subject }.not_to change { user.reload.password_digest }
      end

      it "returns :invalid_token" do
        expect(subject).to eq(:invalid_token)
      end
    end

    context "when token is expired" do
      let(:password) { "newsecurepassword" }
      let(:password_confirmation) { "newsecurepassword" }

      before { user.update(reset_password_sent_at: 3.hours.ago) }

      it "does not reset the password" do
        expect { subject }.not_to change { user.reload.password_digest }
      end

      it "returns :expired_token" do
        expect(subject).to eq(:expired_token)
      end
    end

    context "when passwords do not match" do
      let(:password) { "newsecurepassword" }
      let(:password_confirmation) { "newsecurepassword_butdifferent" }

      it "does not reset the password" do
        expect { subject }.not_to change { user.reload.password_digest }
      end

      it "returns :passwords_do_not_match" do
        expect(subject).to eq(:passwords_do_not_match)
      end
    end

    context "when password is too short" do
      let(:password) { "short" }
      let(:password_confirmation) { "short" }

      it "returns :password_too_short" do
        expect(subject).to eq(:password_too_short)
      end
    end

    context "when password is too long" do
      let(:password) { "a" * 71 }
      let(:password_confirmation) { "a" * 71 }

      it "returns :password_too_long" do
        expect(subject).to eq(:password_too_long)
      end
    end

    context "when password update fails for another reason" do
      let(:password) { "newsecurepassword" }
      let(:password_confirmation) { "newsecurepassword" }

      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
      end

      it "returns :error_saving_password" do
        expect(subject).to eq(:error_saving_password)
      end
    end
  end
end
