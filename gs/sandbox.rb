#  mapgame.rb -  uses Chingu Viewport with Edit
#     Classes -  SandBox,  Explorer


#
#  MAPGAME GAMESTATE CLASS
#
class Sandbox < Chingu::GameState
  trait :viewport    # This adds accessor 'viewport' to class and overrides draw() to use it.
  def initialize(options = {})
    super
    Star.destroy_all
#    game_objects.destroy_all
    self.input = { :escape => :exit, :e => :edit, :p => Pause } 

    Sound["../media/meow1.wav"] # cache sound by accessing it once
    
    self.viewport.lag = 0                           # 0 = no lag, 0.99 = a lot of lag.
    self.viewport.game_area = [0, 0, 1600, 700]    # Viewport restrictions, full "game world/map/area"
    
    load_game_objects
  
    # Create our mechanic star-hunter
    @droid = Explorer.create(:x => 300, :y => 350)    
  end

  def edit
#    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [Droid, Tube, CogWheel, Block, Saw, Battery]))

    state = GameStates::Edit.new(:classes => [Earth, Grey, Droid, Star, Dog, Chicken, Horse, Starship, Circle, Box, Plasma, FireCube, Airplane, Enemy, Blank])
    push_game_state(state)
  end


  def update    
    super

    # Droid can pick up starts
    @droid.each_collision(Star) do |droid, star|
      star.destroy
      Sound["../media/meow1.wav"].play(0.5)
    end
    @droid.each_collision(Dog) do |droid, dog|
      @droid.bark
    end
    
    # Bullets collide with stone_walls
    #Bullet.each_collision(StoneWall) do |bullet, stone_wall|
    #  bullet.die
    #  stone_wall.destroy
    #end
    
    # Destroy game objects that travels outside the viewport
    Bullet.destroy_if { |game_object| self.viewport.outside_game_area?(game_object) }
    
    #
    # Align viewport with the droid in the middle.
    # This will make droid will be in the center of the screen all the time...
    # ...except when hitting outer borders and viewport x_min/max & y_min/max kicks in.
    #
    self.viewport.center_around(@droid)
        
    $window.caption = "BULLETS: #{Bullet.size}x/y: #{@droid.x.to_i}/#{@droid.y.to_i} - viewport x/y: #{self.viewport.x.to_i}/#{self.viewport.y.to_i} - FPS: #{$window.fps}     Press E to edit map."
  end
end


#
#  EXPLORER CLASS
#    Our Player Class
#
class Explorer < Chingu::GameObject
  trait :bounding_box, :debug => false
  traits :timer, :collision_detection , :timer
  attr_accessor :last_x, :last_y, :direction

  def setup
    @initTime = Gosu::milliseconds #the the milliseconds when created
#    @delay = (rand 100)+1 #add a delay to the time so they move differently
    self.input = { :holding_space => :fire, :holding_left => :left, :holding_right => :right, :holding_up => :up,
                   :holding_down => :down  }  # :"2" => :second_player,

    @animations = Chingu::Animation.new(:file => "../media/plyr1.png")#, :center_x => 500, :center_y => 500, :delay => 70)
    @animations.frame_names = { :stand1 => 0..0, :stand2 => 3..3, :walkleft => 1..2, :walkright => 4..5,
                                :blink1 => 6..6, :blink2 => 7..7 }    # Designate frame_names ranges
    @animation = @animations[:walkleft]     # Start out with :walkleft
    @speed = 8
    @last_x, @last_y = @x, @y
    @dir = -1
    update
  end

  def left
    move(-@speed, 0)
    @animation = @animations[:walkleft]
    @dir = -1
  end
  def right
    move(@speed, 0)
    @animation = @animations[:walkright]
    @dir = 1
  end
  def up
    move(0, -@speed)
    if @dir == -1
      @animation = @animations[:walkleft]
    else
      @animation = @animations[:walkright]
    end
  end
  def down
    move(0, @speed)
    if @dir == -1
      @animation = @animations[:walkleft]
    else
      @animation = @animations[:walkright]
    end
  end

  def fire
    FireCube.create(:x => rand(1500), :y => rand(250))
  end

  def bark
    return if @cooling_down2
    @cooling_down2 = true
    after(700) { @cooling_down2 = false }
    if rand(4) == 1
      Sound["../media/sounds/bark4.wav"].play(0.9)
    else
      if rand(3) == 1
        Sound["../media/sounds/bark2.wav"].play(0.9)
      else
        if rand(2) == 1
          Sound["../media/sounds/bark3.wav"].play(0.9)
        else
          if rand(2) == 1
            Sound["../media/sounds/bark1.wav"].play(0.9)
          else
            Sound["../media/sounds/bark5.wav"].play(0.7)
            Sound["../media/sounds/bark6.wav"].play(0.6)          
          end
        end
      end
    end
  end
  
  def move(x,y)
    @x += x         # Revert player to last positions when colliding with at least one Class Grey object
    @x = @last_x  if self.first_collision(Grey)
    @y += y
    @y = @last_y  if self.first_collision(Grey)

    if @x < -65     # wrap around the screen
      @x = 1665
    end
    if @y < -60
      @y = 750
    end
    if @x > 1665
      @x = -65
    end
    if @y > 750
      @y = -60
    end
  end

  def update
    @image = @animation.next
    @blink = false 
    if (milliseconds / 200 % 4 == 2)
      @blink = true
    else
      @blink = false
    end

    if @x == @last_x && @y == @last_y    # Player blinks when standing still
      if @dir == -1
        if @blink
          @animation = @animations [:blink1]
        else
          @animation = @animations [:stand1]
        end
      else
        if @blink
          @animation = @animations [:blink2]
        else
          @animation = @animations [:stand2]
        end
      end
    else
      @direction = [@x - @last_x, @y - @last_y]   # Save the direction to use with bullets when firing
    end

    @last_x, @last_y = @x, @y  # Save last coordinates
  end
end


#
#   From here down is Object Classes for Map Objects
#

class Blank <GameObject
  def setup
    @image = Image["../media/blank.png"]
  end
end

class Grey < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection  
  def setup
    @image = Image["../media/tiles/grey.png"]
  end
end

class Earth < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["../media/tiles/earth.png"]
  end
end

class Chicken < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["../media/tiles/gallina.png"]
  end
end

class Horse < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["../media/tiles/caballo.png"]
  end
end

class Dog < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def setup
    @image = Image["../media/tiles/perro.png"]
  end
end