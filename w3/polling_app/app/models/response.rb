# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  answer_choice_id :integer          not null
#  respondant_id    :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ActiveRecord::Base
  validates :answer_choice_id, :respondant_id, presence: true
  validate :does_not_answer_the_same_question, :improved_does_not_respond_to_own_poll

  belongs_to(
  :answer_choice,
  class_name: 'AnswerChoice',
  foreign_key: :answer_choice_id,
  primary_key: :id
  )

  belongs_to(
  :respondent,
  class_name: 'User',
  foreign_key: :respondant_id,
  primary_key: :id
  )

  has_one(
  :question,
  through: :answer_choice,
  source: :question
  )

  def sibling_responses
    question.responses.where.not(id: self.id)
  end

  private
  def does_not_answer_the_same_question
    if self.sibling_responses.where(:respondant_id => self.respondant_id).exists?
      message = "you already answered this question."
      self.errors[:answer_choice_id] << message
    end
  end

  def does_not_respond_to_own_poll
    if self.question.poll.author_id == self.respondant_id
      message = "you can't answer your own poll."
      self.errors[:answer_choice_id] << message
    end
  end

  # brain teaser
  def improved_does_not_respond_to_own_poll
    poll_author_id = Poll
      .joins(questions: :answer_choices)
      .where("answer_choices.id = ?", self.answer_choice_id)
      .pluck("polls.author_id").first
    if poll_author_id = self.respondant_id
      message = "you can't answer your own poll."
      self.errors[:answer_choice_id] << message
    end
  end
end
