# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])

phoebe = User.where(user_name: 'phoebe').first_or_create!
scott = User.where(user_name: 'scott').first_or_create!
geoff = User.where(user_name: 'geoff').first_or_create!

icecream_poll = Poll.where(title: 'Icecream Poll', author_id: 1).first_or_create!
restaurant_poll = scott.authored_polls.where(title: 'Restau Poll').first_or_create!

icecream_q1 = Question.where(question_body: 'Favorite flavor?', poll_id: 1).first_or_create!
icecream_q2 = Question.where(question_body: 'Favorite topping?', poll_id: 1).first_or_create!
ice_q1_answerchoice_1 = AnswerChoice.where(answer_choice_body: 'Vanilla', question_id: 1).first_or_create!
ice_q1_answerchoice_2 = AnswerChoice.where(answer_choice_body: 'Chocolate', question_id: 1).first_or_create!
ice_q2_answerchoice_1 = AnswerChoice.where(answer_choice_body: 'Caramel', question_id: 2).first_or_create!

restau_q1 = Question.where(question_body: 'Favorite restaurant to visit?', poll_id: 2).first_or_create!
restau_q2 = Question.where(question_body: 'Favoriate food to order?', poll_id: 2).first_or_create!
restau_q1_answerchoice_1 = AnswerChoice.where(answer_choice_body:  'BurgerFi', question_id: 3).first_or_create!
restau_q1_answerchoice_2 = AnswerChoice.where(answer_choice_body:  'Homeskillet', question_id: 3).first_or_create!
restau_q2_answerchoice_1 = AnswerChoice.where(answer_choice_body: 'ScrambeledEgg', question_id: 4).first_or_create!

response1 = Response.where(answer_choice_id: 2, respondant_id: 2).first_or_create!
response2 = Response.where(answer_choice_id: 4, respondant_id: 1).first_or_create!
response3 = Response.where(answer_choice_id: 6, respondant_id: 1).first_or_create!
response4 = Response.where(answer_choice_id: 6, respondant_id: 3).first_or_create!
response5 = Response.where(answer_choice_id: 5, respondant_id: 3).first_or_create!
