require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end

end

class Question

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end

  attr_accessor :table_name, :title, :author_id, :body, :id

  def initialize(options = {})
    @table_name = 'questions'
    @title = options['title']
    @author_id = options['author_id']
    @body = options['body']
    @id = options['id']
  end

  def save
    if self.id.nil?
      create
    else
      QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
        UPDATE
      SQL
    end
  end

  def create
    raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
    INSERT INTO
    questions (title, body, author_id)
    VALUES
    (?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(key_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    results.map { |result| Question.new result }.last
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.author_id = ?
    SQL

    results.map { |result| Question.new result }
  end

  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL

    results.map { |result| User.new result }.last
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollower.followers_for_question_id(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

end


class User

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end

  attr_accessor :table_name, :fname, :lname, :id

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
    @table_name = 'users'
  end

  def create
    raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    INSERT INTO
    users (fname, lname)
    VALUES
    (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(key_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL

    results.map { |result| User.new result }.last
  end

  def self.find_by_name(key_fname, key_lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_fname, key_lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL

    results.map { |result| User.new result }
  end

  def authored_questions
     Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT
      CAST(COUNT(question_likes.liker_id) AS FLOAT) / COUNT(DISTINCT(questions.id))
    FROM
      users
    JOIN
      questions ON questions.author_id = users.id
    LEFT OUTER JOIN
      question_likes ON question_likes.question_id = questions.id
    WHERE
      users.id = ?
    GROUP BY
      users.id
    SQL

    results.last.values.last
  end

end

class QuestionFollower

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end

  attr_accessor :id, :question_id, :follower_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, question_id, follower_id)
    INSERT INTO
    question_followers (question_id, follower_id)
    VALUES
    (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(key_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      id = ?
    SQL

    results.map { |result| QuestionFollower.new result }.last
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_followers ON question_followers.follower_id = users.id
    WHERE
      question_followers.question_id = ?
    SQL

    results.map { |result| User.new result }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_followers ON questions.id = question_followers.question_id
    WHERE
      question_followers.follower_id = ?
    SQL

    results.map { |result| Question.new result }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_followers ON question_followers.question_id = questions.id
    GROUP BY questions.id
    ORDER BY COUNT(question_followers.follower_id) DESC
    SQL

    results.map { |result| Question.new result }.take n
  end

end


class Reply

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
    results.map { |result| Reply.new(result) }
  end

  attr_accessor :id, :question_id, :author_id, :parent_reply_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @author_id = options['author_id']
    @parent_reply_id = options['parent_reply_id']
    @body = options['body']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, question_id, author_id, parent_reply_id, body)
    INSERT INTO
    replies (question_id, author_id, parent_reply_id, body)
    VALUES
    (?, ?, ?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(key_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL

    results.map { |result| Reply.new result }.last
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.question_id = ?
    SQL

    results.map { |result| Reply.new result }
  end

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.author_id = ?
    SQL

    results.map { |result| Reply.new result }.last
  end

  def author
    results = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL

    results.map { |result| User.new result }.last
  end

  def question
    results = QuestionsDatabase.instance.execute(<<-SQL, self.question_id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL

    results.map { |result| Question.new result }.last
  end

  def parent_reply
    results = QuestionsDatabase.instance.execute(<<-SQL, self.parent_reply_id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL

    results.map { |result| Reply.new result }.last
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_reply_id = ?
    SQL

    results.map { |result| Reply.new result }
  end

end

class QuestionLike

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result) }
  end

  attr_accessor :id, :question_id, :liker_id

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @liker_id = options['liker_id']
  end

  def create
    raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, question_id, liker_id)
    INSERT INTO
    question_likes (question_id, liker_id)
    VALUES
    (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(key_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, key_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL

    results.map { |result| QuestionLike.new result }.last
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_likes ON question_likes.liker_id = users.id
    WHERE
      question_likes.question_id = ?
    SQL

    results.map { |result| User.new result }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(users.id)
    FROM
      users
    JOIN
      question_likes ON question_likes.liker_id = users.id
    WHERE
      question_likes.question_id = ?
    GROUP BY
      question_likes.question_id
    SQL

    return 0 if results.empty?
    results.last.values.last
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_likes ON question_likes.question_id = questions.id
    WHERE
      question_likes.liker_id = ?
    GROUP BY
      question_likes.liker_id
    SQL

    results.map { |result| Question.new result }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_likes ON question_likes.question_id = questions.id
    GROUP BY questions.id
    ORDER BY COUNT(question_likes.liker_id) DESC
    SQL

    results.map { |result| Question.new result }.take n

  end

end
