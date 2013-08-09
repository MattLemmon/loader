# zoom.rb (Gosu Tutorial) - Classes:  Zoom,  Starship,  Star

DEBUG = false  # Set to true to see bounding circles used for collision detection

#
#   ZOOM GAMESTATE
#
class Zoom < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :exit, :holding_space => :new_ship, :p => Pause }
    @score = 0
    @score_text = Text.create("Score: #{@score}", :x => 10, :y => 10, :zorder => 55, :size=>20)
  end

  def setup
    super
    Starship.destroy_all
    Star.destroy_all
    @player = Starship.create(:zorder => 4, :x=>400, :y=>300)
  end

  def new_ship
    Starship.create(:zorder => 3, :x=>400, :y=>300, :angle=>rand(360))
  end

  def update
    super
    @score_text.text = "Score: #{@score}"
    $window.caption = "GosuTutorial - " + @score_text.text
    if rand(100) < 5 && Star.all.size < 30
      Star.create
    end
    
    Starship.each_collision(Star) do |starship, star|    # Collide starships with stars
      star.destroy
      @score+=10
    end
  end
end

#
#   STARSHIP CLASS
#
class Starship < GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :collision_detection, :effect, :velocity
  
  def initialize(options={})
    super(options)
    @image = Image["../media/Starfighter.bmp"]
    self.input = {:holding_right=>:turn_right, :holding_left=>:turn_left, :holding_up=>:accelerate, :holding_down=>:brakes}
    self.max_velocity = 20
  end

  def brakes
    self.velocity_x = Gosu::offset_x(self.angle, 0.01)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, 0.01)*self.max_velocity_y
  end

  def accelerate
    self.velocity_x = Gosu::offset_x(self.angle, 0.6)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, 0.6)*self.max_velocity_y
  end
  
  def turn_right
    # The same can be achieved without trait 'effect' as: self.angle += 4.5
    rotate(4.5)
  end
  
  def turn_left
    # The same can be achieved without trait 'effect' as: self.angle -= 4.5
    rotate(-4.5)
  end
  
  def update
    self.velocity_x *= 0.97 # dampen the movement
    self.velocity_y *= 0.97
    
    @x %= $window.width # wrap around the screen
    @y %= $window.height
  end
end

#
#   STAR CLASS
#
class Star < GameObject
  trait :bounding_circle, :debug => DEBUG
  trait :collision_detection
  
  def initialize(options={})
    super
    @animation = Chingu::Animation.new(:file => "../media/Star.png", :size => 25)
    @image = @animation.next
    self.zorder = 1
    self.color = Gosu::Color.new(0xff000000)
    self.color.red = rand(255 - 40) + 40
    self.color.green = rand(255 - 40) + 40
    self.color.blue = rand(255 - 40) + 40
    self.x =rand * 900
    self.y =rand * 700
    
    #
    # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
    # Same is true for "cache_bounding_box"
    #
    cache_bounding_circle
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation.next
  end
end

