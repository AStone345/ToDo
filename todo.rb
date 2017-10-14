# User interface menu module
module Menu
	def menu
		puts "Welcome to the to-do list!
			Select from this menu:
			A) Add task
			D) Delete task
			U) Update task
			T) Toggle task status as complete or not
			S) Show all tasks
			F) Write to a text file 
			R) Read from a file
			Q) Quit the program"
	end

	def show
		menu
	end
end

# Prompt module for user input
module Promptable
	def prompt(message="What would you like to do?", symbol = ":> ")
		print message 
		print symbol
		gets.chomp
	end
end

#List class
class List 
	attr_reader :all_tasks

	def initialize
		@all_tasks = []
	end

	#add a task to the list
	def add(task)
		all_tasks.push(task)
	end

	# displays all tasks
	def show
		all_tasks.map.with_index { |task, index| "#{index.next}) #{task.to_machine}" }
	end

	# write the task list to a text file
	def write_to_file(filename)
		IO.write(filename, all_tasks.map(&:to_machine).join("\n"))
	end

	# read tasks from a text file
	def read_from_file(filename)
		IO.readlines(filename).each { |task| 
			status, *description = task.split(' : ')
			add(Task.new(description.join(' : ').strip, status.include?('X'))) }
	end

	# delete task selected by index number
	def delete(task_number)
		all_tasks.delete_at(task_number - 1)
	end

	# Update the task 
	def update(task_number, task)
		all_tasks[task_number - 1] = task
	end

	def toggle(task_number)
		all_tasks[task_number - 1].toggle_status
	end
end

#Task class
class Task
	attr_reader :description
	attr_accessor :status

	def initialize(description, status = false)
		@description = description
		@status = status
	end

	# return the description of the task to a string for readability
	def to_s
		description
	end

	# Tells if task is completed
	def completed?
		status
	end

	# Display the status and description of the task
	def to_machine
		"#{represent_status} : #{description}" 
	end

	# Toggle the complete/not complete stauts of the task
	def toggle_status
		@status = !completed?
	end

	private
	def represent_status
		completed? ? "[X]" : "[ ]"
	end
end

if __FILE__ == $PROGRAM_NAME
    include Menu
    include Promptable
    test_list = List.new
    puts 'Please choose from the following list:'
    	until ['q'].include?(user_input = prompt(show).downcase)
    		case user_input
    			when "a" then test_list.add(Task.new(prompt("What is the task you would like to add?")))
    			when "s" then puts test_list.show
    			when "t" then puts test_list.show
    				test_list.toggle(prompt("Which task would you like to change the status for?").to_i)
    			when "u" then puts test_list.show
    				test_list.update(prompt("Which task would you like to update?").to_i, Task.new(prompt("New task description?")))
    			when "f" then test_list.write_to_file(prompt "What is the name of the file you want to write to?")
    			when "r" then test_list.read_from_file(prompt "What file would you like to read from?")
    			when "d" then puts test_list.show
    				test_list.delete(prompt("Which task would you like to remove?").to_i)
    			else puts "Sorry, I did not understand."
    		end
    	end
    puts "Outro - Thanks for using the menu system!"
end