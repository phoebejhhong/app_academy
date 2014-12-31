# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  question_body :text             not null
#  poll_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Question < ActiveRecord::Base
  validates :question_body, :poll_id, presence: true
  after_destroy :log_destroy_action

  has_many(
  :answer_choices,
  class_name: 'AnswerChoice',
  foreign_key: :question_id,
  primary_key: :id
  )

  belongs_to(
  :poll,
  class_name: 'Poll',
  foreign_key: :poll_id,
  primary_key: :id
  )

  has_many(
  :responses,
  through: :answer_choices,
  source: :responses
  )

  def log_destroy_action
    puts 'responses destroyed!'
  end

  # generates N + 1 queries
  def bad_results
    answer_choice_count = {}
    answer_choices = self.answer_choices
    answer_choices.each do |answer_choice|
      answer_choice_count[answer_choice.answer_choice_body] = answer_choice.responses.length
    end

    answer_choice_count
  end

  def results
    answer_choice_count = {}
    answer_choices = self.answer_choices.includes(:responses)
    answer_choices.each do |answer_choice|
      answer_choice_count[answer_choice.answer_choice_body] = answer_choice.responses.length
    end

    answer_choice_count
  end

  def best_results
    # Question.find_by_sql([<<-SQL, self.id])
    # SELECT answer_choices.*, COUNT(*)
    # FROM answer_choices
    # LEFT OUTER JOIN responses
    # ON answer_choices.id = responses.answer_choice_id
    # WHERE answer_choices.question_id = ?
    # GROUP BY
    # answer_choices.id
    # SQL

    answer_choice_count = {}

    self.answer_choices
      .select('answer_choices.*, COUNT(DISTINCT responses.id) AS response_count')
      .joins('LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id')
      .group('answer_choices.id').each{ |ac| answer_choice_count[ac.answer_choice_body] =
        ac.response_count}

      answer_choice_count
  end

end
