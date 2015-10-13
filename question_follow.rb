class QuestionFollow

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.follower_id
      WHERE
        question_follows.question_id = ?
      SQL

    results.map {|result| User.new(result)}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      WHERE
        question_follows.follower_id = ?
      SQL

    results.map {|result| Question.new(result)}
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        question.id = question_follows.question_id
      GROUP BY
        question.id
      ORDER BY
        COUNT(*) DESC
      LIMIT ?
    SQL

    results.map {|result| Question.new(result)}
  end
end
