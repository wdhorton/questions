require_relative 'model_base.rb'

class Reply < ModelBase

  DATABASE_NAME = "replies"

  attr_accessor :question_id, :parent_reply_id, :user_id, :body

  def initialize(opts={})
    opts = opts[0] if opts.is_a?(Array)
    super(opts['id'])
    @question_id, @parent_reply_id, @user_id, @body =
      opts.values_at('question_id', 'parent_reply_id', 'user_id', 'body')
  end

  def author
    User.find_by_id(user_id)
  end

  def question
    Question.find_by_id(question_id)
  end

  def parent_reply
    Reply.find_by_id(parent_reply_id) if parent_reply_id
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
      SQL

    results.map {|result| Reply.new(result)}
  end

end
