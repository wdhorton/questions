require_relative 'model_base.rb'

class Question < ModelBase

  DATABASE_NAME = "questions"


  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(opts={})
    opts = opts[0] if opts.is_a?(Array)
    @id, @title, @body, @author_id = opts.values_at('id', 'title', 'body', 'author_id')
  end

  def author
      User.find_by_id(author_id)

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

end
