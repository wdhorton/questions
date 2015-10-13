class ModelBase
  attr_reader :id

  def self.all
    results = QuestionsDatabase.instance.execute("SELECT * FROM #{self::DATABASE_NAME}")
    results.map { |result| self.new(result) }
  end

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
      where_exp = options.map { |k, v| k.to_s + " = " + "'" + v.to_s + "'" }.join(" AND ")
    end

    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::DATABASE_NAME}
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

  def initialize(id)
    @id = id
  end

  def save
    params, attributes = params_and_attr

    if id.nil?
      create(params,attributes)
    else
      update(params,attributes)
    end
  end

  private

  def create(params,attributes)
    QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        #{self.class::DATABASE_NAME} (#{attributes.join(', ')})
      VALUES
        (#{question_marks(params.length)})
      SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
    puts "Saved!"
  end

  def update(params,attributes)
    attributes.delete('id')
    params.delete(id)
    attr_str = attributes.map { |attribute| attribute + " = ?" }.join(', ')
    QuestionsDatabase.instance.execute(<<-SQL, *params, id)
      UPDATE
        #{self.class::DATABASE_NAME}
      SET
        #{attr_str}
      WHERE
        id = ?
      SQL
    puts "Updated!"
  end

  def question_marks(n)
    question_marks = []
    n.times do
      question_marks << "?"
    end
    question_marks.join(', ')
  end

  def params_and_attr
    params = []
    attributes = instance_variables.map { |var| var.to_s[1..-1]}

    attributes.each do |name|
      params << self.send(name.to_sym)
    end
    [params,attributes]
  end

end
