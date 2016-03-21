class Score < ActiveRecord::Base

  belongs_to   :user

  validates  :user_id,
             :whore_count,
             :total_time, presence: true

end
