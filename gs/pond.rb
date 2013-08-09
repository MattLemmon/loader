#   pond.rb - Classes:  Pond,  Fish

#
#   POND GAMESTATE CLASS
#
class Pond < Chingu::GameState
  def initialize(options = {})
    super
    self.input = {:space => :new_fish, :holding_up => :speed_up, :holding_down => :slow_down, :p => Pause}
  end

  def setup
    Particle.destroy_all
    Fish.destroy_all
    @bluish = Color.new(0xFF688B9B)
    @bubbles = Chingu::Animation.new(:file => ("../media/particle.png"), :size => [32,32])
    @count_a = 200
    @count_b = 300
    @count = 8
    @fish_x = 440
    @fish_y = 330
    new_fish
  end

  def new_fish
    Fish.create(:x => @fish_x, :y => @fish_y)
    @fish_x += 209
    if @fish_x >= 900
      @fish_x -= 890
      @fish_y += 121
    end
    if @fish_y >= 700
      @fish_y -= 680
    end
  end

  def speed_up
    if @count < 300
      @count += 1
    end
  end
  def slow_down
    if @count > 1
      @count -= 1
    end
  end

  def update
    if @count_a >= 400
      Chingu::Particle.create( :x => rand(900), :y => $window.height, :image => "../media/particle.png", :color => @bluish, :mode => :additive )
      @count_a = 0
    else
      @count_a += @count
    end
    if @count_b >= 670
      Chingu::Particle.create( :x => 3, :y => rand(700), :image => "../media/particle.png", :color => @bluish, :mode => :additive )
      @count_b = 0
    else
      @count_b += @count
    end
    Particle.each { |particle| particle.y -= 1; particle.x += 2.5 - rand(4) }
    game_objects.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
    super
  end

  def draw
    Image["../media/bowl.png"].draw(0, 0, 0) # Background Image
    $window.caption = "Bowl"
    super
  end
end


#
#  FISH CLASS
#
class Fish < Chingu::GameObject
  traits :timer
 
  def initialize(gamestate)
    super
#    @delay_rate = delay_rate
    self.input = { :holding_right => :factorize, :holding_left => :defactor } # :up => :factorize, :down => :defactor,
    # Load the full animation from tile-file
    @animation = Chingu::Animation.new(:file => "../media/fish.png", :center_x => 500, :center_y => 500, :delay => 50)
    @animation.frame_names = { :swim => 0..5, :s0=>0..0, :s1=>1..1, :s2=>2..2, :s3=>3..3, :s4=>4..4, :s5=>5..5 }
    # Start out by animation contained in @animation[:swim]
    @frame_name = :swim
    self.factor = 0.5
  end

  def factorize
    self.factor *= 1.05
  end

  def defactor
    self.factor *= 0.95
  end

  def update       # Move the animation forward by fetching the next frame and putting it into @image
    @image = @animation[@frame_name].next           # @image is drawn by default by GameObject#draw
  end
end

