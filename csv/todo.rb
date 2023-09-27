require 'csv'
require 'time'

# Create csv file if it's absent
unless File.exists?('todo.csv')
  CSV.open('todo.csv', 'w') do |csv|
    csv << [:task_number, :title, :description, :completed, :due_date, :created_date]
  end
end

# Fetch data from csv file in table format
def todo
  CSV.table('todo.csv', headers: true,  header_converters: :symbol)
end

$task_number = 0
$todo = todo

# Read task number from last row of csv
unless $todo.empty?
  $task_number = todo[todo.length - 1][:task_number].to_i
end

# Display whole todo list
def get_list
  return puts "\nList is empty" if $todo.empty?

  puts "\nYour Todo List\n--------------"
  $todo.each do |row|
    view_task(row.field(:task_number))
  end
end

# Display particular task from todo list
def get_task
  return puts "\nList is empty" if $todo.empty?

  puts 'Enter task number :'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless valid_task?(task_number)

  puts "\nSelected task\n-------------"
  view_task(task_number)
end

# Display task corresponding to task number from todo list
def view_task(task_number)
  return puts "\nList is empty" if $todo.empty?

  task = $todo.values_at(index_of_task(task_number)).pop
  
  puts "Task Number : #{task.field(:task_number)}\n"\
       "Title : #{task.field(:title)}\n"\
       "Description : #{task.field(:description)}\n"\
       "Completed : #{task.field(:completed)}\n"\
       "Due Date : #{task.field(:due_date)}\n"\
       "Created Date : #{task.field(:created_date)}\n\n"
end

# Add task to todo list
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

  $task_number += 1
  completed = false
  created_date = Time.now.strftime("%d-%m-%Y")

  CSV.open('todo.csv', 'a') do |csv|
    csv << [$task_number, title, description, completed, due_date, created_date]
  end

  $todo = todo
end

# Update a task value from todo list
def edit_task
  return puts "\nList is empty" if $todo.empty?

  puts 'Enter task number'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless valid_task?(task_number)

  puts "\nSelected task\n-------------"
  puts view_task(task_number)

  puts "Which field do you want to update :\n"
  field = gets.chomp.strip.downcase.squeeze(' ').gsub(' ','_').to_sym

  return puts "\nCannot edit that field" if [:task_number, :created_date].include?(field)
  return puts "\nInvalid field" unless valid_field?(field)

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

  $todo[index_of_task(task_number)][field] = value
  update_todo

  puts "\nUpdated task\n-------------"
  puts view_task(task_number)
end

# Delete an entry from todo list
def delete_task
  return puts "\nList is empty" if $todo.empty?

  puts 'Enter task number'
  task_number = gets.chomp.strip.to_i

  return puts "\nInvalid task number" unless valid_task?(task_number)
  
  $todo.delete(index_of_task(task_number))
  update_todo

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

# Check if task number is present in the todo list
def valid_task?(task_number)
  $todo.values_at(:task_number).flatten.include?(task_number)
end

# Check if field is a valid attribute on the todo list
def valid_field?(field)
  $todo.headers.include?(field)
end

# Get index corresponding to task number in the todo list
def index_of_task(task_number)
  $todo.values_at(:task_number).flatten.index(task_number)
end

# Update csv file with values from the todo list
def update_todo
  new_csv = CSV.parse($todo.to_csv)
  index = 0

  CSV.open('todo.csv', 'w') do |csv|
    until index == new_csv.length
      csv << new_csv[index]
      index += 1
    end
  end
end

puts "\nWelcome to Todo list."

loop do
  puts "\nMenu\n----\n"\
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
  else puts "\nPlease enter a valid option\n"
  end
end
