require 'rake'

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
        gem_root.slice! "/commands"
        puts "root #{root}\n"
        gem_root_s = gem_root + "/*"
        gem_root_ss = gem_root + "/*/*"
        puts " gem_root #{gem_root_s}\n"
        lib_files = FileList[ gem_root_s, gem_root_ss ].to_a
        #puts "lib_files vale #{lib_files}"
        not_copy_files = ["commands", "description", "version"]
  
        not_copy_files.each do |not_copy|
          lib_files.delete_if do |element|
            element.include? not_copy 
          end
        end
        
        lib_files.each do |file|
          puts "Copiando file #{file}\n"
          file.slice!(gem_root) 
          puts "primera parte #{file}\n"
          
          puts "a root #{root + '/src/gosu_android' + file }\n\n"
          #FileUtils.mkdir_p(File.dirname(root + "/src"))
          #FileUtils.cp(file, dst)        
        end
        puts "antes " + gem_root
        gem_root = gem_root + "/"
        gem_root.slice! "/gosu_android/"
        puts "despues " + gem_root
        puts gem_root + "/gosu_android.rb\n"
        puts gem_root + "/gosu.java.jar.rb\n"
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
          