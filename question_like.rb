class QuestionLike

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes
      ON
        users.id = question_likes.liker_id
      WHERE
        question_likes.question_id = ?
      SQL

    results.map {|result| User.new(result)}
  end

  def self.num_likes_for_question_id(question_id)
    result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        questions
      JOIN
        question_likes
      ON
        question.id = question_likes.question_id
      WHERE
        question.id = ?
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      JOIN
        users
      ON
        question_likes.liker_id = users.id
      WHERE
        users.id = ?
    SQL

    results.map {|result| Question.new(result)}
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes
      ON
        question.id = question_likes.question_id
      GROUP BY
        question.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    results.map {|result| Question.new(result)}
  end

end
