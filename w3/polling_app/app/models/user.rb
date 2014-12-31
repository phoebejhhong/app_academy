# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
  :authored_polls,
  class_name: 'Poll',
  foreign_key: :author_id,
  primary_key: :id
  )

  has_many(
  :responses,
  class_name: 'Response',
  foreign_key: :respondant_id,
  primary_key: :id
  )

  def completed_polls
    polls_completion_count
      .having("COUNT(DISTINCT questions.id) = COUNT(responses_by_user.id)")
  end

  def uncompleted_polls
    polls_completion_count
    .having("COUNT(DISTINCT questions.id) > COUNT(responses_by_user.id)")
  end

  private
  def polls_completion_count
    # Poll.find_by_sql([<<-SQL, self.id])
    #   SELECT
    #     polls.*,
    #     COUNT(DISTINCT questions.id) AS total_count,
    #     COUNT(responses_by_user.id) AS each_count
    #   FROM
    #     polls
    #   JOIN
    #     questions ON questions.poll_id = polls.id
    #   LEFT OUTER JOIN
    #     answer_choices ON answer_choices.question_id = questions.id
    #   JOIN (
    #     SELECT
    #       *
    #     FROM
    #       responses
    #     WHERE
    #       responses.respondant_id = ?
    #   ) AS responses_by_user
    #   ON responses_by_user.answer_choice_id = answer_choices.id
    #   GROUP BY
    #     polls.id
    #   HAVING
    #     total_count = each_count
    # SQL

    select_sql = <<-SQL
      polls.*,
      COUNT(DISTINCT questions.id) AS total_count,
      COUNT(responses_by_user.id) AS each_count
    SQL

    join_sql = <<-SQL
      JOIN (
        SELECT
        *
        FROM
        responses
        WHERE
        responses.respondant_id = #{self.id}
      ) AS responses_by_user ON responses_by_user.answer_choice_id = answer_choices.id
    SQL

    Poll
     .select(select_sql)
     .joins(questions: :answer_choices)
     .joins(join_sql)
     .group("polls.id")
  end
end
