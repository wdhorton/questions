require_relative 'model_base.rb'

class Question < ModelBase

  # def self.all
  #   results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
  #   results.map { |result| Question.new(result) }
  # end
  #
  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute('SELECT * FROM question WHERE id = ?', id)
  #   Question.new(result)
  # end
  #
  # def self.find_by_author_id(author_id)
  #   results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
  #     SELECT
  #       *
  #     FROM
  #       questions
  #     WHERE
  #       author_id = ?
  #   SQL
  #   results.map { |result| Question.new(result) }
  # end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(opts={})
    @id, @title, @body, @author_id = opts.values_at('id', 'title', 'body', 'author_id')
  end

  def author
      Author.find_by_id(author_id)

  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
  #
  # def save
  #   params = [title, body, author_id]
  #
  #   if id.nil?
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       INSERT INTO
  #         questions (title, body, author_id)
  #       VALUES
  #         (?, ?, ?)
  #       SQL
  #
  #     self.id = QuestionsDatabase.instance.last_insert_row_id
  #   else
  #     QuestionsDatabase.instance.execute(<<-SQL, *params)
  #       UPDATE
  #         questions (title, body, author_id)
  #       VALUES
  #         (?, ?, ?)
  #       SQL
  #   end
  # end
  #
end
