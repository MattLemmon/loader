# ex7.rb - Classes: Fill, FillRect, FillGrdnt, FillGrdntMultClrs, FillGrdntRect, ParticleDisplay


#
# GFXHelpers example - demonstrating Chingus GFX
#

class Fill < Chingu::GameState 
  def setup
    Fish.create(:x => $window.width/2, :y => $window.height/2, :zorder => 0)
    @bluey = Color.new(0xFF688B9B)
  end
  def update
  end
  def draw
    $window.caption = "fill (enter to continue)"
    fill(@bluey)
  end
end

class FillRect < Chingu::GameState 
  def draw
    $window.caption = "fill_rect (enter to continue)"
    fill_rect([10,10,100,100], Color::WHITE)
  end
end

class FillGrdnt < Chingu::GameState 
  def setup
    @pinkish = Color.new(0xFFCE17B6)
    @blueish = Color.new(0xFF6DA9FF)
  end
  
  def draw
    $window.caption = "fill_gradient (enter to continue)"
    fill_gradient(:from => @pinkish, :to => @blueish, :orientation => :vertical)
  end
end

class FillGrdntMultClrs < Chingu::GameState
  def setup
    @colors = [ 0xffff0000, 0xff00ff00, 0xff0000ff ].map { |c| Color.new(c) }
  end
  
  def draw
    $window.caption = "fill_gradient with more than two colors (enter to continue)"
    fill_gradient(:colors => @colors, :orientation => :horizontal)
  end
end

class FillGrdntRect < Chingu::GameState 
  def setup
    @color1 = Color.new(0xFFFFEA02)
    @color2 = Color.new(0xFF078B20)
  end
  
  def draw
    $window.caption = "fill_gradient with :rect-option (enter to continue)"
    fill_gradient(:from => @color1, :to => @color2, :rect => [100,100,200,200], :orientation => :horizontal)
  end
end

class ParticleDisplay < Chingu::GameState
  def setup
    Particle.destroy_all
    self.input = { :p => Pause }
    @color1 = Color.new(0xFFFFEA02)
    @color2 = Color.new(0xFF078B20)
    @blue_laserish = Color.new(0xFF86EFFF)
    @red = Color.new(0xFFFF0000)
    @white = Color.new(0xFFFFFFFF)
    @yellow = Color.new(0xFFF9F120)
    
    # Thanks jsb in #gosu of Encave-fame for fireball.png :)
    @fireball_animation = Chingu::Animation.new(:file => ("../media/fireball.png"), :size => [32,32])
    @ground_y = $window.height * 0.95
  end
  
  def update
    #
    # Fire 1. Dies quickly (big :fade). Small in size (small :zoom)
    #
    Chingu::Particle.create( :x => 100, 
                          :y => @ground_y, 
                          :animation => @fireball_animation,
                          :scale_rate => +0.05, 
                          :fade_rate => -10, 
                          :rotation_rate => +1,
                          :mode => :default
                        )

    #
    # Fire 2. Higher flame, :fade only -4. Wide Flame with bigger :zoom.
    #
    Chingu::Particle.create( :x => 300, 
                          :y => @ground_y, 
                          :animation => @fireball_animation, 
                          :scale_rate => +0.2, 
                          :fade_rate => -4, 
                          :rotation_rate => +3,
                          :mode => :default
                        )
    #
    # Fire 3. Blue plasma with smooth particle.png and color-overlay.
    #
    Chingu::Particle.create( :x => 500, 
                          :y => @ground_y,
                          :image => "../media/particle.png", 
                          :color => @blue_laserish,
                          :mode => :additive
                        )

    Particle.each { |particle| particle.y -= 5; particle.x += 2 - rand(4) }
    game_objects.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
    super
  end
  
  def draw
    $window.caption = "particle example (enter to continue) [particles#: #{game_objects.size} - framerate: #{$window.fps}]"
    fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
    fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
    super
  end
end
