
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '50m' do
    UpdateMessagesCounterJob.perform_async
    UpdateChatsCounterJob.perform_async
end