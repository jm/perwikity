require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

desc 'Default: run specs'
task :default => :spec

desc "Run the specs under spec"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ["--format", "progress", "--color"]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Generate RCov reports"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems', '--exclude', 'riddle']
end

desc "One file, one line, one spec."
Spec::Rake::SpecTask.new(:target) do |t|
  t.spec_opts = ["--format", "progress", "--color", "-l", ENV['line']]
  t.spec_files = FileList["spec/unit/#{ENV['unit']}_spec.rb"]
end

desc "Repeat the tests many times to find failures."
task :repeat do
  100.times do
    output = `rake spec --trace`
    puts output
    break unless output =~ /0 fail/
  end
end
