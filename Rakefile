CLASSES_DIR = 'pkg/classes'
JAVA_SOURCES = 'java/*'

unless ENV['ANDROID_HOME']
  begin
    adb_path = `which adb`
    ENV['ANDROID_HOME'] = File.dirname(File.dirname(adb_path)) if $? == 0
  rescue Errno::ENOENT
    puts "Unable to detect adb location: #$!"
  end
end
(puts 'You need to set the ANDROID_HOME environment variable.'; exit 1) unless ENV['ANDROID_HOME']

directory CLASSES_DIR

desc 'Generate the gosu.java.jar'
task :jar => [CLASSES_DIR] + FileList[JAVA_SOURCES] do
  sh "javac -source 1.6 -target 1.6 -bootclasspath \"#{ENV['ANDROID_HOME']}/platforms/android-10/android.jar\" -d #{CLASSES_DIR} #{JAVA_SOURCES}"
  sh "jar cf lib/gosu.java.jar -C #{CLASSES_DIR} gosu"
end

desc 'Build the gem'
task :gem => :jar do
  sh 'gem build gosu_android.gemspec'
  sh 'mv gosu_android-*.gem pkg/'
end
