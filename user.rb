require_relative 'model_base'

class User < ModelBase

  DATABASE_NAME = "users"

  def self.find_by_name(fname, lname)
    options = {"fname" => fname, "lname" => lname}
    self.where(options)
  end

  attr_accessor :fname, :lname

  def initialize(opts={})
    opts = opts[0] if opts.is_a?(Array)
    super(opts['id'])
    @fname, @lname = opts.values_at('fname', 'lname')
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

end
