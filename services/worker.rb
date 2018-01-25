class Worker
  attr_accessor :number, :tasks, :workers

  def initialize
    @number = 800
    @tasks = Queue.new
  end

  def add_task(&task)
    @tasks << task
  end

  def work
    @workers = Array.new(@number) do
      Thread.new do
        until @tasks.empty?
          task = @tasks.pop
          task.call
        end
      end
    end
    @workers.each(&:join)
    @tasks.length
  end
end
