require "sidekiq-scheduler"

class TestHelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Hello World from TestHelloWorldJob!"
  end
end
