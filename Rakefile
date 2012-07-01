#!/usr/bin/env rake
task :cd_lib do
  FileUtils.cd 'lib'
end

task :compile_haml do
  sh "haml index.haml index.html"
end

task :compile_coffee do
  sh "coffee -c jsColorUnblinder.coffee"
  sh "coffee -c background.coffee"
end

task :copy_files do
  required_files = %w{ index.html jsColorUnblinder.js background.js }
  required_files.each do |file|
    sh "cp #{file} ../extension/"
  end
end


task :default => [:cd_lib, :compile_haml, :compile_coffee, :copy_files]
