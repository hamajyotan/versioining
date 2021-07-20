class User < ApplicationRecord
  self.primary_key = :id
  # self.primary_key = %i[id version]
  default_scope -> { where(version: 0) }

  before_save :increment_version
  before_destroy :increment_version

  def create_or_update(...)
    @new_record = true
    write_attribute :updated_at, nil
    super
  end

  def changed_attribute_names_to_save
    mutations_from_database.changed_attribute_names | %w[id created_at]
  end

  def destroy
    @new_record = true
    super
  end

  private

  def increment_version
    self.class.unscoped.where(id: id).update_all('version = version + 1')
  end
end
