# jungle.rb  -  Classes:  Scroller,  Jungle

# Parallax-example from Chingu Tutorial
# Background Images from http://en.wikipedia.org/wiki/Parallax_scrolling

#
#   SCROLLER GAMESTATE CLASS
#
class Scroller < Chingu::GameState  
  def initialize(options = {})
    super(options)
    @text_color = Color.new(0xFF000000)
    self.input =  { :holding_left => :camera_left, :holding_right => :camera_right, :holding_up => :camera_up,
                    :holding_down => :camera_down, :space => :meow, :p => Pause   }   
  end
    
  def meow
    if rand(3) == 1
      Sound["../media/meow1.wav"].play(0.4)
    else
      if rand(2) == 1
        Sound["../media/meow2.wav"].play(0.4)
      else
        Sound["../media/meow3.wav"].play(0.3)
      end
    end
  end
  
  def camera_left
    @parallax.camera_x -= 2     # This is essentially the same as @parallax.x += 2
  end
    def camera_right
    @parallax.camera_x += 2     # This is essentially the same as @parallax.x -= 2
  end  
  def camera_up
    @parallax.camera_y -= 2     # This is essentially the same as @parallax.y += 2
  end
  def camera_down
    @parallax.camera_y += 2    # This is essentially the same as @parallax.y -= 2
  end
end

#
#   JUNGLE GAMESTATE INHERITS FROM SCROLLER
#
class Jungle < Scroller
  def setup
    $window.caption = "Jungle"
    Parallax.destroy_all
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left)
  
    #
    # If no :zorder is given to @parallax.add_layer it defaults to first added -> lowest zorder
    # Everywhere the :image argument is used, these 2 values are the Same:
    # 1) Image["foo.png"]  2) "foo.png"
    #
    # Notice we add layers to the parallax scroller in 3 different ways. 
    # They all end up as ParallaxLayer-instances internally
    #
    @parallax.add_layer(:image => "layer-sky.png", :damping => 100)
    @parallax.add_layer(:image => "layer-mount.png", :damping => 10)
    @parallax.add_layer(:image => "layer-cat.png", :x => 0, :y => 460, :damping => -1)
    @parallax.add_layer(:image => "layer-trees.png", :x => 0,  :y => 610, :damping => 5)
    @parallax << Chingu::ParallaxLayer.new(:image => "layer-grass.png", :damping => 3, :parallax => @parallax)
    @parallax << {:image => "layer-sand.png", :damping => 1}

    Chingu::Text.create("Jungle", :x => 0, :y => 0, :size => 30, :color => @text_color)

    Sound["../media/meow1.wav"]  # cache sounds by accessing once
    Sound["../media/meow2.wav"]
    Sound["../media/meow3.wav"]
  end

end
