require 'runner'
require 'set'


class ComplexRunner < SequentialRunner
  def initialize(*strategies)
    @strategies = strategies
  end

  private

  def check_property(p)
    run = Set.new
    @strategies.each { |s| s.set_property(p) }
    unless @strategies.all? { |s| s.exhausted? }
      failed = false
      @time = Time.new
      while @strategies.any?{ |s| !s.exhausted? } and !failed and
          (Time.new - @time) < 20
        sts = @strategies.select { |s| !s.exhausted? }
        sts.each do |s|
          g = s.generate
          unless run.include?(g)
            run << g
            notify_step
            failed = !eval_property(p, g)
            break if failed
          end
        end
      end
      notify_success unless failed
    else
      notify_failure('No test cases could be generated')
    end
  end
end
