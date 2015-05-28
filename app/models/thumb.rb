class Thumb < ActiveRecord::Base
  belongs_to :song

  def down?; not up?; end
  def down=(val); self.up = !val; end
end
