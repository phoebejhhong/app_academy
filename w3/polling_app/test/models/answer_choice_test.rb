# == Schema Information
#
# Table name: answer_choices
#
#  id                 :integer          not null, primary key
#  answer_choice_body :text             not null
#  question_id        :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class AnswerChoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
