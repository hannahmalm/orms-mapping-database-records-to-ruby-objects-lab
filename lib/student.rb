class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    #get the students id which will be the first in the array
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
  end

  def self.all
    # retrieve all the rows from the "Students" database using the wildcard
    # remember each row should be a new instance of the Student class
    #the DB con and the loop will be the same for every instance
    sql = <<- SQL
      SELECT * 
      FROM students
    SQL 
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 
  end

  def self.find_by_name(name)
    #when you dont know the name use a ? 
    #to only find one record limit 1 and end.first
    sql = <<- SQL 
      SELECT *
      FROM students
      WHERE name = ? 
      LIMIT 1
    SQL 

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    #this is the standard save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    #check to see if table exists first, otherwise make it and connect to db
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
