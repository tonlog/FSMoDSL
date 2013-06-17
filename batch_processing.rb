
class Tasklist < Array;end

class Task < Proc
    def execute
        self.call
    end
end

class BatchProcessing

    def accept_tasklist new_tasklist
        @current_tasklist = new_tasklist
    end

    def do_these tasks
        tasks.each do |task|
            task.call
        end
    end

    def execute
        do_these @current_tasklist
    end

    private :do_these

end

task1 = Task.new {puts 'Do A'}
task2 = Task.new {puts 'Do B'}
task3 = Task.new {puts 'Do C'}

tasklist = Tasklist.new
tasklist << task1 << task2 << task3