require 'sqlite3'

class TodoModel
  @db = SQLite3::Database.open "todo_database.db"
  @table = 'TodoList'
  @task_number = 'task_number'
  @title = 'title'
  @description = 'description'
  @completed = 'completed'
  @due_date = 'due_date'
  @created_date = 'created_date'

  @db.execute "CREATE TABLE IF NOT EXISTS #{@table} ("\
              "#{@task_number} INTEGER PRIMARY KEY,"\
              "#{@title} TEXT,"\
              "#{@description} TEXT,"\
              "#{@completed} TEXT,"\
              "#{@due_date} TEXT,"\
              "#{@created_date} TEXT)"

  def self.get_list
    @db.execute "SELECT * FROM #{@table}"
  end

  def self.get_task(task_number)
    @db.execute "SELECT * "\
                "FROM #{@table} "\
                "WHERE #{@task_number} = #{task_number}"
  end

  def self.set_task(task_number, title, description, completed, due_date, created_date)
    @db.execute "INSERT INTO #{@table} "\
                "VALUES (#{task_number},'#{title}','#{description}','#{completed}','#{due_date}','#{created_date}')"
  end

  def self.edit_task(task_number, field, value)
    @db.execute "UPDATE #{@table} "\
                "SET #{field} = '#{value}' "\
                "WHERE #{@task_number} = #{task_number}"
  end

  def self.delete_task(task_number)
    @db.execute "DELETE FROM #{@table} "\
                "WHERE #{@task_number} = #{task_number}"
  end

  def self.clear_list
    @db.execute "DROP TABLE #{@table}"
  end

  def self.get_task_numbers
    @db.execute "SELECT #{@task_number} "\
                "FROM #{@table}"
  end

  def self.get_last_task_number
    @db.execute "SELECT #{@task_number} "\
                "FROM #{@table} "\
                "ORDER BY #{@task_number} DESC "\
                "LIMIT 1"
  end

  def self.get_fields
    @db.execute "SELECT name "\
                "FROM pragma_table_info('#{@table}')"
  end

  def self.close_db
    @db&.close
  end
end
