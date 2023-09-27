require 'time'

class Todo
  @@todo_list = {}
  @@task_number = 0
  
  def initialize(title, description, due_date)
    @@task_number += 1
    @title = title
    @description = description
    @completed = false
    @due_date = due_date
    @created_date = Time.now.strftime("%d-%m-%Y")
    
    @@todo_list[@@task_number] = {
      :task_number => @@task_number,
      :title => @title, 
      :description => @description, 
      :completed => @completed, 
      :due_date => @due_date, 
      :created_date => @created_date
    }
  end

  def self.get_list
    @@todo_list
  end

  def self.get_task(task_number)
    @@todo_list[task_number]
  end

  def self.edit_task(task_number, field, value)
    @@todo_list[task_number][field] = value
  end
  
  def self.delete_task(task_number)
    @@todo_list.delete(task_number)
  end

  def self.key?(key)
    @@todo_list.key?(key)
  end

  def self.empty?
    @@todo_list.empty?
  end
end

# Display the whole todo list
def get_list
  return puts "\nList is empty" if Todo.empty?

  puts "\nYour Todo List\n--------------"
  Todo.get_list.values.map { |task| view_task(task[:task_number]) }
end

# Display a particular task from the todo list
def get_task
  return puts "\nList is empty" if Todo.empty?

  puts 'Enter task number :'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless Todo.key?(task_number)

  puts "\nSelected task\n-------------"
  view_task(task_number)
end

# Display task corresponding to the task number
def view_task(task_number)
  return puts "\nList is empty" if Todo.empty?

  task = Todo.get_task(task_number)
  
  puts "Task Number : #{task[:task_number]}\n"\
       "Title : #{task[:title]}\n"\
       "Description : #{task[:description]}\n"\
       "Completed : #{task[:completed]}\n"\
       "Due Date : #{task[:due_date]}\n"\
       "Created Date : #{task[:created_date]}\n\n"
end

# Add a task to the todo list 
def set_task
  puts "\nEnter title :"
  title = gets.chomp.strip

  return puts 'Title cannot be empty' if title.empty?

  puts 'Enter description (optional) :'
  description = gets.chomp.strip
  
  puts 'Enter due date [DD-MM-YYYY] (optional) :'
  due_date = gets.chomp.strip

  unless due_date.empty?
    return puts "\nInvalid date" unless valid_date?(due_date)
  
    due_date = Time.parse(due_date).strftime("%d-%m-%Y")
    return puts "\nDue date cannot be in the past" if past_date?(due_date)
  end

  task = Todo.new(title, description, due_date)
end

# Update a task from the todo list
def edit_task
  return puts "\nList is empty" if Todo.empty?

  puts 'Enter task number'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless Todo.key?(task_number)

  puts "\nSelected task\n-------------"
  puts view_task(task_number)


  puts "Which field do you want to update :\n"
  field = gets.chomp.strip.downcase.squeeze(' ').gsub(' ','_').to_sym

  return puts "\nCannot edit that field" if [:task_number, :created_date].include?(field)
  return puts "\nInvalid field" unless Todo.get_task(task_number).key?(field)

  puts "\nEnter new #{field.to_s.gsub('_',' ')} #{'[DD-MM-YYY]' if field == :due_date} :\n"
  value = gets.chomp.strip

  if field == :title && value.empty?
    return puts "\nTitle cannot be empty"
  end

  # Ensuring value is boolean in completed status field
  if field == :completed
    return puts "\nInvalid input" unless ['false', 'true'].include?(value)
    value = eval(value)
  end

  # Ensuring input due date is valid
  if field == :due_date && !value.empty?
    return puts "\nInvalid date" unless valid_date?(value)

    value = Time.parse(value).strftime("%d-%m-%Y")

    if Time.parse(value) < Time.parse(Todo.get_task(task_number)[:created_date])
      return puts "\nDue date cannot be before task created date" 
    end
  end

  Todo.edit_task(task_number,field,value)

  puts "\nUpdated task\n-------------"
  puts view_task(task_number)
end

# Delete a task from the todo list
def delete_task
  return puts "\nList is empty" if Todo.empty?

  puts 'Enter task number'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless Todo.key?(task_number)
  
  Todo.delete_task(task_number)
  puts "\nTask #{task_number} deleted"
end

# Check if date is valid
def valid_date?(date)
  Time.parse(date)
  return true
rescue
  return false
end

# Check if date is in the past
def past_date?(date)
  Time.parse(Time.now.to_s) > Time.parse(date)
end

puts "\nWelcome to Todo list.\n\n"

loop do
  puts "Menu\n----\n"\
       "1. List All Tasks\n"\
       "2. Display One Task\n"\
       "3. Create Task\n"\
       "4. Edit Task\n"\
       "5. Delete Task\n"\
       "6. Exit\n\n"\
       "Choose an option :"

  option = gets.chomp.strip.to_i
  
  case option
  when 1 then get_list
  when 2 then get_task
  when 3 then set_task
  when 4 then edit_task
  when 5 then delete_task
  when 6 then exit
  else puts "\nPlease enter a valid option"
  end
end
