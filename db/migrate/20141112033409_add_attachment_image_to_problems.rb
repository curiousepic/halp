class AddAttachmentImageToProblems < ActiveRecord::Migration
  def self.up
    change_table :problems do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :problems, :image
  end
end
