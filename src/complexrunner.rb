require 'runner'


class ComplexRunner < SequentialRunner
  def initialize(*strategies)
    @strategies = strategies
  end

  private

    # contar tiempo
  # utilizar set para filtrar casos duplicados

  # al final del todo mirar si abstraer algo para compartir codigo
  # con simple runner

  def check_property(p)
    @strategies.each { |s| s.set_property(p) }
    unless @strategies.all? { |s| s.exhausted? }
      failed = false
      @time = Time.new
      while @stategies.any? { |s| !s.exhausted? } and !failed and
          (Time.new - time) < 20
        sts = @strategies.select { |s| !s.exhausted? }
        sts.each do |s|
          notify_step
          failed = !eval_property(p, s.generate)
          break if failed
        end
        # generar y ejecutar si procede
        # notify_step solo si hay que ejecutar
      end
      notify_success unless failed
    else
      notify_failure('No test cases could be generated')
    end
  end
end
