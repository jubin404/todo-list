class Todo
  require 'time'

  @todo_list = {}
  @task_number = 0

  def self.get_list
    @todo_list
  end

  def self.get_task(task_number)
    @todo_list[task_number]
  end

  def self.update_task(task_number, field, value)
    @todo_list[task_number][field] = value
  end

  def self.delete_task(task_number)
    @todo_list.delete(task_number)
  end

  def self.empty?
    @todo_list.empty?
  end

  def self.clear_list
    @todo_list = {}
    @task_number = 0
  end

  # Add task to todo list
  def self.set_task(title, description, due_date)
    @task_number += 1
    @title = title
    @description = description
    @completed = false
    @due_date = due_date
    @created_date = Time.now.strftime('%d-%m-%Y')

    @todo_list[@task_number] = {
      :task_number => @task_number,
      :title => @title,
      :description => @description,
      :completed => @completed,
      :due_date => @due_date,
      :created_date => @created_date
    }
  end

  # Display task corresponding to the task number
  def self.display_task(task_number)
    return puts 'List is empty' if self.empty?

    task = get_task(task_number)

    puts "Task Number : #{task[:task_number]}\n"\
         "Title : #{task[:title]}\n"\
         "Description : #{task[:description]}\n"\
         "Completed : #{task[:completed]}\n"\
         "Due Date : #{task[:due_date]}\n"\
         "Created Date : #{task[:created_date]}\n\n"
  end

  # Display the whole todo list
  def self.view_list
    return puts 'List is empty' if empty?

    puts "Your Todo List\n--------------"
    get_list.values.map { |task| display_task(task[:task_number]) }
  end

  # Display a particular task from the todo list
  def self.view_task
    return puts 'List is empty' if empty?

    puts 'Enter task number :'
    task_number = gets.chomp.strip.to_i

    return puts "\nInvalid task number" unless @todo_list.key?(task_number)

    puts "Selected task\n-------------"
    display_task(task_number)
  end

  # Add a task to the todo list from user input
  def self.add_task
    puts 'Enter title :'
    title = gets.chomp.strip

    return puts 'Title cannot be empty' if title.empty?

    puts 'Enter description (optional) :'
    description = gets.chomp.strip

    puts 'Enter due date [DD-MM-YYYY] (optional) :'
    due_date = gets.chomp.strip

    unless due_date.empty?
      return puts "\nInvalid date" unless valid_date?(due_date)

      due_date = Time.parse(due_date).strftime('%d-%m-%Y')
      return puts "\nDue date cannot be in the past" if past_date?(due_date)
    end

    set_task(title, description, due_date)
  end

  # Update a task from the todo list from user input
  def self.edit_task
    return puts 'List is empty' if empty?

    puts 'Enter task number'
    task_number = gets.chomp.strip.to_i

    return puts "Invalid task number" unless @todo_list.key?(task_number)

    puts "Selected task\n-------------"
    puts display_task(task_number)

    puts "\nWhich field do you want to update :\n"
    field = gets.chomp.strip.downcase.squeeze(' ').gsub(' ','_').to_sym

    return puts "Cannot edit that field" if %i[task_number created_date].include?(field)
    return puts "Invalid field" unless get_task(task_number).key?(field)

    puts "\nEnter new #{field.to_s.gsub('_',' ')} #{'[DD-MM-YYY]' if field == :due_date} :\n"
    value = gets.chomp.strip

    return puts "\nTitle cannot be empty" if field == :title && value.empty?

    # Ensuring value is boolean in completed status field
    if field == :completed
      return puts "\nInvalid input" unless %w[false true].include?(value)

      value = eval(value)
    end

    # Ensuring input due date is valid
    if field == :due_date && !value.empty?
      return puts "\nInvalid date" unless valid_date?(value)

      value = Time.parse(value).strftime("%d-%m-%Y")

      if Time.parse(value) < Time.parse(get_task(task_number)[:created_date])
        return puts "\nDue date cannot be before task created date" 
      end
    end

    update_task(task_number, field, value)

    puts "Updated task\n-------------"
    puts display_task(task_number)
  end

  # Delete a task from the todo list from user input
  def self.remove_task
    return puts 'List is empty' if empty?

    puts 'Enter task number'
    task_number = gets.chomp.strip.to_i

    return puts "\nInvalid task number" unless @todo_list.key?(task_number)

    delete_task(task_number)
    puts "Task #{task_number} deleted"
  end

  # Check if date is valid
  def self.valid_date?(date)
    Time.parse(date)
    true
  rescue
    false
  end

  # Check if date is in the past
  def self.past_date?(date)
    Time.parse(Time.now.to_s) > Time.parse(date)
  end

  private_class_method :valid_date?, :past_date?
end
