require File.expand_path('model.rb', __dir__)

class TodoController < TodoModel
  require 'date'

  @task_number = TodoModel.get_last_task_number.flatten.pop || 0
  @fields = TodoModel.get_fields.flatten

  def self.todo
    TodoModel.get_list
  end

  def self.task_numbers
    TodoModel.get_task_numbers.flatten
  end

  def self.get_task(task_number)
    TodoModel.get_task(task_number)
  end

  def self.update_task(task_number, field, value)
    TodoModel.edit_task(task_number, field, value)
  end

  def self.delete_task(task_number)
    TodoModel.delete_task(task_number)
  end

  def self.clear_list
    TodoModel.clear_list
  end

  # Add task to todo list
  def self.set_task(title, description, due_date)
    @task_number += 1
    completed = 'false'
    created_date = Time.now.strftime('%d-%m-%Y')

    TodoModel.set_task(@task_number, title, description, completed, due_date, created_date)
  end

  # Display task corresponding to the task number
  def self.display_task(task_number)
    return puts "\nList is empty" if todo.empty?

    task = get_task(task_number).flatten

    puts "Task Number : #{task[0]}\n"\
         "Title : #{task[1]}\n"\
         "Description : #{task[2]}\n"\
         "Completed : #{task[3]}\n"\
         "Due Date : #{task[4]}\n"\
         "Created Date : #{task[5]}\n\n"
  end

  # Display the whole todo list
  def self.view_list
    return puts "\nList is empty" if todo.empty?

    puts "\nYour Todo List\n--------------"
    todo.map { |task| display_task(task[0]) }
  end

  # Display a particular task from the todo list
  def self.view_task
    return puts "\nList is empty" if todo.empty?

    puts 'Enter task number :'
    task_number = gets.chomp.strip.to_i

    return puts "\nInvalid task number" unless task_numbers.include?(task_number)

    puts "\nSelected task\n-------------"
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
    puts "\nTask added to todo list."
  end

  # Update a task from the todo list from user input
  def self.edit_task
    return puts "\nList is empty" if todo.empty?

    puts 'Enter task number'
    task_number = gets.chomp.strip.to_i

    return puts "\nInvalid task number" unless task_numbers.include?(task_number)

    puts "Selected task\n-------------"
    puts display_task(task_number)

    puts "\nWhich field do you want to update :\n"
    field = gets.chomp.strip.downcase.squeeze(' ').gsub(' ', '_')

    return puts "\nCannot edit that field" if %w[task_number created_date].include?(field)
    return puts "\nInvalid field" unless @fields.include?(field)

    puts "\nEnter new #{field.to_s.gsub('_', ' ')} #{'[DD-MM-YYY]' if field == 'due_date'} :\n"
    value = gets.chomp.strip

    return puts "\nTitle cannot be empty" if field == 'title' && value.empty?

    # Ensuring value is boolean in completed status field
    if field == 'completed'
      return puts "\nInvalid input" unless %w[false true].include?(value)

      value = eval(value)
    end

    # Ensuring input due date is valid
    if field == 'due_date' && !value.empty?
      return puts "\nInvalid date" unless valid_date?(value)

      value = Time.parse(value).strftime('%d-%m-%Y')

      if Time.parse(value) < Time.parse(get_task(task_number)[5])
        return puts "\nDue date cannot be before task created date"
      end
    end

    update_task(task_number, field, value)

    puts "Updated task\n-------------"
    puts display_task(task_number)
  end

  # Delete a task from the todo list from user input
  def self.remove_task
    return puts "\nList is empty" if todo.empty?

    puts 'Enter task number'
    task_number = gets.chomp.strip.to_i

    return puts "\nInvalid task number" unless task_numbers.include?(task_number)

    delete_task(task_number)
    puts "\nTask #{task_number} deleted"
  end

  def self.exit_app
    TodoModel.close_db
    exit
  end

  # Check if date is valid
  def self.valid_date?(date)
    Date.parse(date)
    true
  rescue
    false
  end

  # Check if date is in the past
  def self.past_date?(date)
    Date.parse(Time.now.to_s) > Date.parse(date)
  end

  private_class_method :task_numbers, :display_task, :valid_date?, :past_date?
end
