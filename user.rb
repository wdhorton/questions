require_relative 'model_base'

class User < ModelBase
  #
  # def self.all
  #   results = QuestionsDatabase.instance.execute('SELECT * FROM users')
  #   results.map { |result| User.new(result) }
  # end
  #
  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute('SELECT * FROM users WHERE id = ?', id)
  #   User.new(result)
  # end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    User.new(result)
  end

  attr_accessor :id, :fname, :lname

  def initialize(opts={})
    opts = opts[0] if opts.is_a?(Array)
    @id, @fname, @lname = opts.values_at('id','fname', 'lname')
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        COUNT(DISTINCT questions.id) / CAST(COUNT(question_likes.liker_id) AS FLOAT)
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        questions.author_id = ?
      SQL

    result[0].values[0]
  end
  #
  # def save
  #   params = [fname, lname]
  #
  #   if id.nil?
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       INSERT INTO
  #         users (fname, lname)
  #       VALUES
  #         (?, ?)
  #       SQL
  #
  #     self.id = QuestionsDatabase.instance.last_insert_row_id
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       UPDATE
  #         users (fname, lname)
  #       VALUES
  #         (?, ?)
  #       SQL
  #   end
  # end

end
