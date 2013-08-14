#   droid.rb - Classes: DroidGame, Droid, Bullet


#
#   DroidGame GAMESTATE CLASS
#      Animation / retrofy example from Chingu Tutorial
#
class DroidGame < Chingu::GameState
  def initialize(options = {})
    super
#    Sound["media/intro.ogg"].play(0.2) # Intro Music
  end

  def setup
#    self.game_objects.destroy_all
    Droid.destroy_all
    Bullet.destroy_all
    Droid.create(:x => $window.width/2, :y => $window.height/2)
#    @droid = Droid.new(:x => $window.width/2, :y => $window.height/2)
    self.input = {:p => Pause}
    $window.caption = "Droid Game"
  end

  def draw
    Image["../media/plax3.png"].draw(0, 0, 0) # Background Image

    super
  end
end



#
#
#  DROID CLASS
#
class Droid < Chingu::GameObject
  traits :timer, :velocity
  attr_accessor :last_x, :last_y, :direction

#  def initialize(options = {})
#    super
  def setup
    self.factor = 5
    # array-setup for self.input
    self.input = [:holding_left, :holding_right, :holding_up, :holding_down, :space ]
    
    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => "droid_11x15.png")
    @animation.frame_names = { :scan => 0..5, :up => 6..7, :down => 8..9, :left => 10..11, :right => 12..13 }
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :scan
    @last_x, @last_y = @x, @y
    @s = -1
    @s_count = 5
    update
  end
    
  def holding_left
    @x -= 8
    @frame_name = :left
  end

  def holding_right
    @x += 8
    @frame_name = :right
  end
  
  def holding_up
    @y -= 8
    @frame_name = :up
  end

  def holding_down
    @y += 8
    @frame_name = :down
  end

  def space
    @s_count += 1
    if @s_count >= 9
      @s *= -1
      @s_count = 1
    end
    self.factor += @s
    self.fire
  end

  def fire
    Bullet.create(:x => self.x, :y => self.y - 20, :velocity => @direction)
#    Bullet.create(:x => @x, :y => @y) 
#    Bullet.create(:x => @x, :y => @y + 20)
#    Bullet.create(:x => @x, :y => @y - 20)
    #puts "current_scope: #{$window.current_scope.to_s}"
    #puts "inside_state: #{$window.game_state_manager.inside_state}"
  end  

  def update
  #We don't need to call super() in update().
  #By default GameObject#update is empty since it doesn't contain any gamelogic to speak of.
    # Move the animation forward by fetching the next frame and putting it into @image
    @image = @animation[@frame_name].next # @image is drawn by default by GameObject#draw

    if @x == @last_x && @y == @last_y             # droid stands still, use the scanning animation
      @frame_name = :scan
    else
      @direction = [@x - @last_x, @y - @last_y]   # Save the direction to use with bullets when firing
    end

    if @x < -30     # wrap around beyond screen edges
      @x = 930
    end
    if @y < -50
      @y = 750
    end
    if @x > 930
      @x = -30
    end
    if @y > 750
      @y = -50
    end

#    @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
    @last_x, @last_y = @x, @y                     # save current coordinates for possible use next time
  end
end


#
# BULLET CLASS
#
class Bullet < Chingu::GameObject
  traits :velocity

  def setup
    @image = Image["../media/fire_bullet.png"]
    self.velocity_x *= 2
    self.velocity_y -= 5
  end
  
  def update
    self.velocity_y += 0.5
#    @y += 1
  end

end

