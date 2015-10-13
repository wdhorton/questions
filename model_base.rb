class ModelBase

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM #{self.database_name}")
    results.map { |result| self.new(result) }
  end

  # def self.find_by_id(id)
  #   result = QuestionsDatabase.instance.execute("SELECT * FROM #{self.database_name} WHERE id = ?", id)
  #   self.new(result)
  # end

  def self.database_name
    if self == Reply
      "replies"
    else
      self.to_s.downcase + "s"
    end
  end

  def self.where(options = {})
    if options.class == String
      where_exp = options
    else
      where_exp = options.map { |k, v| k.to_s + " = " + v.to_s }.join(" AND ")
    end

    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.database_name}
      WHERE
        #{where_exp}
    SQL
    results.map! { |result| self.new(result) }
    results.length == 1 ? results[0] : results
  end

  def self.method_missing(method, *args)
    method = method.to_s

    if method.start_with?("find_by")
      columns = method[8..-1].split("_and_")

      opts = {}
      columns.each_with_index do |col, i|
        opts[col] = args[i]
      end

      self.where(opts)
    else
      raise "method_missing"
    end


  end

  def save
    params = []
    names = instance_variables
    names.each do |name|
      params << self.name
    end

    question_marks = []
    params.length.times do
      question_marks << "?"
    end

    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *params)
        INSERT INTO
          #{self.class.database_name} (#{names.join(', ')})
        VALUES
          (#{question_marks.join(', ')})
        SQL

      self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, *params)
        UPDATE
          #{self.class.database_name} (#{names.join(', ')})
        VALUES
          (#{question_marks.join(', ')})
        SQL
    end
  end

end
