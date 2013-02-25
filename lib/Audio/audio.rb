require 'lib/requires'

module Gosu
  MAX_SAMPLES = 10
  class SampleInstance
    def initialize
      
    end
  end
  
  class AudioFocusListener
      def onAudioFocusChange focusChange
        puts "In focus change #{focusChange}"
      end
      
      def toString
        self.class.to_s
      end    
  end
  
  #TODO ManageAudioFocus, when app loses, stop song
  #TODO Raise a warning is the file could not be loaded
  class Sample
    
    #Constructs a sample that can be played on the specified audio
    #system and loads the sample from a file.        
    def initialize(window, filename)
      @window = window
      #Set finalize
      ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)       
      if not defined? @@pool
        @@pool = JavaImports::SoundPool.new(MAX_SAMPLES, JavaImports::AudioManager::STREAM_MUSIC, 0) 
      end  
      
      if(filename.class == Fixnum )
        @id = @@pool.load( @window.activity.getApplicationContext, filename, 1 )
      else
        @id = @@pool.load(filename, 1)
      end     
    end
    
    #Plays the sample without panning.
    #\param volume Can be anything from 0.0 (silence) to 1.0 (full
    #volume).
    #\param speed Playback speed is only limited by the underlying audio library,
    #and can accept very high or low values. Use 1.0 for
    #normal playback speed.    
    def play(volume = 1, speed = 1, looping = false)
      if looping == false
        @stream_id = @@pool.play(@id, volume, volume, 1, 0, 1.0)
      else
        @stream_id = @@pool.play(@id, volume, volume, 1, 1, 1.0)
      end
    end
    
    #TODO Pan is not supported so it is ignored
    def play_pan(pan = 0, volume = 1, speed = 1, looping = false)
      if looping == false
        @stream_id = @@pool.play(@id, volume, volume, 1, 0, 1.0)
      else
        @stream_id = @@pool.play(@id, volume, volume, 1, 1, 1.0)
      end
    end
    
    def Sample.finalize(id)
      @@pool.unload(@id)
    end    
    
  end
  
  #TODO Error on playing several songs, bear in mind mediaplayer states
  #FIXME Set listener for when the data finished loading asynchronously
  # add some checks play is reached before that
  class Song
    attr_reader :current_song
    def initialize(window, filename)
      @window = window      
      if not defined? @@media_player
        @@media_player = JavaImports::MediaPlayer.new
        @@audio_focus_listener = AudioFocusListener.new
        context = @window.activity.getApplicationContext
        @@audio_manager = context.getSystemService(Context::AUDIO_SERVICE)                
        focus = @@audio_manager.requestAudioFocus(@@audio_focus_listener, JavaImports::AudioManager::STREAM_MUSIC, JavaImports::AudioManager::AUDIOFOCUS_GAIN)         
      else
        @@media_player.reset
        focus = @@audio_manager.requestAudioFocus(@@audio_focus_listener, JavaImports::AudioManager::STREAM_MUSIC, JavaImports::AudioManager::AUDIOFOCUS_GAIN)  
      end  
      
      if filename.class == Fixnum
        afd = @window.activity.getApplicationContext.getResources.openRawResourceFd(filename)
        filename = afd.getFileDescriptor
      end        
      
      @@media_player.on_prepared_listener = (proc{media_player_ready})
      @@media_player.setDataSource filename 
      @@media_player.prepareAsync       
      @player_ready = false
      @window.media_player = @@media_player
      @playing = false  
      @file_name = filename   

      if not defined? @@current_song
        @@current_song = 0
      end  
    end

    def media_player_ready
      @player_ready = true
      #Song should be playing but media player was not ready
      #so start playing now
      if @playing
        @@media_player.start
      end
    end
    
    #Starts or resumes playback of the song. This will stop all other
    #songs and set the current song to this object.    
    def play(looping = false)
      @@media_player.setLooping(looping)
      if @player_ready      
        @@media_player.start
      end 
      @@current_song = @file_name
      @playing = true
    end
    
    #Pauses playback of the song. It is not considered being played.
    #currentSong will stay the same.    
    def pause
      if @player_ready 
        @@media_player.pause
      end 
      @playing = false
    end
    
    #Returns true if the song is the current song, but in paused
    #mode.    
    def paused?
      not @playing and @@current_song == @file_name
    end
    
    #Returns true if the song is currently playing.
    def playing?
      @playing and @@current_song == @file_name
    end
    
    #Stops playback of this song if it is currently played or paused.
    #Afterwards, current_song will return 0.     
    def stop
      if @player_ready
        @@media_player.pause
        @@media_player.stop
      end  
      @@current_song = 0
    end
        
  end
  
end
