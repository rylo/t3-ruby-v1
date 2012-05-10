#!/usr/bin/ruby

class EnvSample  
    
  # how to detect operating system platform  
  # check presence of win32 for Windows, linux for Linux etc.  
  def printOSInfo  
    puts RUBY_PLATFORM # RUBY_PLATFORM constant contains OS info    
  end  
    
  # how to get enviornment variable in Ruby  
  # ENV constant contains a hash of enviornment variables  
  def printEnvVariables  
    puts ENV.inspect  
  end  
    
  # how to get command line parameters in Ruby  
  # ARGV constant contains command line parameters  
  def printCommandParams  
    puts ARGV.inspect # ARGV[0] represents first parameter  
  end  
    
  e = EnvSample.new  
  e.printOSInfo # print OS info  
  e.printEnvVariables # print enviornment variables  
  e.printCommandParams # print command line parameters  
end  