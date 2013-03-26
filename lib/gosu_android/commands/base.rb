
module Gosu
  module Commands
    module Base

      def self.show_help
        puts "Usage: gosu_android [OPTION]"
        puts "Adds or deletes dependencies for Gosu in a Ruboto project."
        puts "If no argument is specified it adds the dependencies."  
        puts ""
        puts " -a, --add adds the files to the project"
        puts " -d, --delete deletes the files from the project"
        puts " -h, --help display this help and exit"
        puts ""
        puts "The options -a and -d can not be given together."
        puts ""
        puts "Exit status:"
        puts " 0 if everything went ok,"
        puts " 1 if there was some error."
      end 
      
      def self.add_files 
        root = Dir.pwd
        gem_root = File.expand_path(File.dirname(__FILE__))
        puts "añadiendo #{root} #{gem_root}"
        lib_files = FileList[ gem_root + 'gosu_android/lib/**/*'].to_a do |file|
          #FileUtils.mkdir_p(File.dirname(root + "/src"))
          #FileUtils.cp(file, dst)        
        end
      end
      
      def self.delete_files 
        root = Dir.pwd
        puts "Borrando"
      end 

      def self.main
       add = false
       delete = false
       help = false
        ARGV.each do|a|
          case a
          when "-a" 
            add = true
          when "--add"
            add = true
          when "-d"
            delete = true
          when "--delete" 
            delete = true
          when "-h" 
            help = true
          when "--help"
            help = true
          end    
        end
        
        if help 
          show_help
          exit 0
        end
        
        if add and delete
          $stderr.puts "Add and delete can not be perform at the same time\n"
          exit 1
        end 
        
        if not add and not delete
          add = true
        end
        
        if add 
          add_files
          exit 0
        end    
        
        if delete 
          delete_files
          exit 0
        end 

        
      end
      
      

      
    end
  end
end
          