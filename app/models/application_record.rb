class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

    # アップロードされた画像のサイズをバリデーションする
    def icon_size
      if icon.size > 5.megabytes
        errors.add(:icon, "should be less than 5MB")
      end
    end
end
