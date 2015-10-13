require_relative 'model_base.rb'

class Reply < ModelBase
  #
  # def self.all
  #   results = QuestionsDatabase.instance.execute('SELECT * FROM replies')
  #   results.map { |result| Reply.new(result) }
  # end
  #
  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute('SELECT * FROM replies WHERE id = ?', id)
  #   Reply.new(result)
  # end
  #
  # def self.find_by_user_id(user_id)
  #   results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
  #     SELECT
  #       *
  #     FROM
  #       replies
  #     WHERE
  #       author_id = ?
  #   SQL
  #   results.map { |result| Reply.new(result) }
  # end
  #
  # def self.find_by_question_id(question_id)
  #   results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
  #     SELECT
  #       *
  #     FROM
  #       replies
  #     WHERE
  #       question_id = ?
  #   SQL
  #   results.map { |result| Reply.new(result) }
  # end



  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def initialize(opts={})
    opts = opts[0] if opts.is_a?(Array)
    @id, @question_id, @parent_reply_id, @user_id, @body = opts.values_at('id', 'question_id', 'parent_reply_id', 'user_id', 'body')
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
  #
  # def save
  #   if id.nil?
  #
  #   params = [question_id, parent_reply_id, author_id, body]
  #   if id.nil?
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       INSERT INTO
  #         questions (question_id, parent_reply_id, author_id, body)
  #       VALUES
  #         (?, ?, ?, ?)
  #       SQL
  #
  #     self.id = QuestionsDatabase.instance.last_insert_row_id
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       UPDATE
  #         questions (question_id, parent_reply_id, author_id, body)
  #       VALUES
  #         (?, ?, ?, ?)
  #       SQL
  #
  #   end
  # end

end
