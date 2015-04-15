class AddProfilePictureToUsers < ActiveRecord::Migration
  def change
    add_attachment :user, :profile_picture # Uses Paperclip and Amazon S3
  end
end
