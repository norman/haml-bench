namespace :bench do

  task :haml3 do
    ENV['BUNDLE_GEMFILE'] = "Gemfile.haml3.rb"
    sh "bundle"
    sh "bundle exec ./bench.rb"
  end

  task :haml4 do
    ENV['BUNDLE_GEMFILE'] = "Gemfile.haml4.rb"
    sh "bundle"
    sh "bundle exec ./bench.rb"
  end

  task :master do
    ENV['BUNDLE_GEMFILE'] = "Gemfile.master.rb"
    sh "bundle"
    sh "bundle exec ./bench.rb"
  end
end
