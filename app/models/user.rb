class User < ApplicationRecord
  self.primary_key = :id
  # self.primary_key = %i[id version]
  default_scope -> { where(version: 0) }

  before_save :increment_version
  before_destroy :increment_version

  private

  def increment_version
    self.class.unscoped.where(id: id).update_all('version = version + 1')
  end
end
