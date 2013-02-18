#!/usr/bin/env ruby

require "bundler/setup"
require 'benchmark'
require 'haml'

class HamlBenchmarks
  def initialize

    template_name ||= 'standard.haml'

    @iterations = 1000
    @benches    = []
    @options    = {:format => :html5}
    @template   = File.expand_path("../#{template_name}", __FILE__)

    @haml_code = File.read(@template)

    puts "Using Haml " + Haml::VERSION
    puts "Template: #{@template}"
    puts `uname -a`
    puts `ruby --version`
    puts "-" * 72
    puts "\n"

    init_compiled_benches
    init_cached_benches
    init_parsing_benches
  end

  def init_compiled_benches
    context = Object.new
    haml_pretty = Haml::Engine.new(@haml_code, @options)
    haml_ugly   = Haml::Engine.new(@haml_code, @options.merge(:ugly => true))

    haml_pretty.def_method(context, :run_haml_pretty)
    haml_ugly.def_method(context, :run_haml_ugly)

    bench('compiled haml pretty') { context.run_haml_pretty }
    bench('compiled haml ugly')   { context.run_haml_ugly }
  end

  def init_cached_benches
    haml_pretty = Haml::Engine.new(@haml_code, @options)
    haml_ugly   = Haml::Engine.new(@haml_code, @options.merge(:ugly => true))

    bench('cached haml pretty') { haml_pretty.render }
    bench('cached haml ugly')   { haml_ugly.render }
  end

  def init_parsing_benches
    bench('parsed haml pretty') { Haml::Engine.new(@haml_code, @options).render }
    bench('parsed haml ugly')   { Haml::Engine.new(@haml_code, @options.merge(:ugly => true)).render }
  end

  def run
    puts "#{@iterations} Iterations"
    Benchmark.bmbm do |x|
      @benches.each do |name, block|
        x.report name.to_s do
          @iterations.to_i.times { block.call }
        end
      end
    end
  end

  def bench(name, &block)
    @benches.push([name, block])
  end
end

HamlBenchmarks.new.run
