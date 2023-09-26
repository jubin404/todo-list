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
end

def get_list
  return puts 'List is empty' if Todo.get_list.values.empty?

  puts "\nYour Todo List :\n"
  Todo.get_list.values.map { |task| view_task(task[:task_number]) }
end

def get_task
  puts 'Enter task number :'
  task_number = gets.chomp.to_i

  view_task(task_number)
end

def view_task(task_number)
  task = Todo.get_task(task_number)
  
  puts "\nTask Number : #{task[:task_number]}\n"\
  "Title : #{task[:title]}\n"\
  "Description : #{task[:description]}\n"\
  "Completed : #{task[:completed]}\n"\
  "Due Date : #{task[:due_date]}\n"\
  "Created Date : #{task[:created_date]}\n"\
end

def set_task
  puts 'Enter title :'
  title = gets.chomp
  
  puts 'Enter description (optional) :'
  description = gets.chomp
  
  puts 'Enter due date [DD-MM-YYYY] (optional) :'
  due_date = gets.chomp
  
  task = Todo.new(title, description, due_date)
end

def edit_task
  puts 'Enter task number'
  task_number = gets.chomp.to_i

  puts "\nCurrent task : \n"
  puts view_task(task_number)

  puts "Which field do you want to update :\n"
  field = gets.chomp.downcase.squeeze(' ').gsub(/\s/,'_').to_sym

  puts "\nEnter new value :\n"
  value = gets.chomp

  Todo.edit_task(task_number,field,value)

  puts "\nUpdated task : \n"
  puts view_task(task_number)
end

def delete_task
  puts 'Enter task number'
  task_number = gets.chomp.to_i

  Todo.delete_task(task_number)
end

puts "\nWelcome to Todo list."

loop do
  puts "\nMenu\n"\
  "1. List All Tasks\n"\
  "2. Display One Task\n"\
  "3. Create Task\n"\
  "4. Edit Task\n"\
  "5. Delete Task\n"\
  "6. Exit\n\n"\
  "Choose an option :"

  option = gets.chomp.to_i
  
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
