require 'Open3'

module Fastlane
  module Helper
    class XamarinBuildHelper
      def self.bash(command, disable_log)
        UI.message("starting bash process with command: #{command}")

        if disable_log
          stderr_str, status = Open3.capture2("#{command} > /dev/null")
          if status != 0
            UI.error(stderr_str)
            raise 'not 0 result'
          end
        else
          Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
            error = []
            t1 = Thread.start do
              stdout.each { |line| UI.command_output(line) }
            end
            t2 = Thread.start do
              stderr.each { |line| error << line }
            end
            exit_status = wait_thr.value
            t1.join
            t2.join
            if exit_status != 0
              error.each { |e| UI.error(e) }
              raise 'not 0 result'
            end
          end
        end
      end
    end
  end
end
