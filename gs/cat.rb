#    cat.rb - Classes:  Cat, Gato, Player2

#
#  CAT GAMESTATE CLASS
#    Cat GameState
#
class Cat < Chingu::GameState
  def initialize(options = {})
    super
    $window.caption = "Additional Controls:   spacebar  A  W  S  D"
    self.input = {:p => Pause, :r => lambda{ current_game_state.setup } }
    Sound["../media/sounds/meow1.wav"]   # cache sounds by accessing once
    Sound["../media/sounds/meow2.wav"]
    Sound["../media/sounds/meow3.wav"]
  end
  def setup
    Gato.destroy_all
    Player2.destroy_all
    Gato.create(:x => $window.width/3, :y => $window.height/2)
  end
  def draw
    # Background Image
    Image["../media/blank.png"].draw(0, 0, 0)
    super
  end
end


#  GATO CLASS
#    Player Class "Gato"
#
class Gato < Chingu::GameObject
  traits :timer
 
  def initialize(window)
    super
    self.input = { :m => :meow, [:space, :"2"] => :second_player, :holding_left => :left, :holding_right => :right,
                   :holding_up => :up, :holding_down => :down     }
    @animation = Chingu::Animation.new(:file => "../media/plyr1.png", :center_x => 500, :center_y => 500,
                                       :delay => 70)          # Load the full animation from tile-image
    @animation.frame_names = { :stand1 => 0..0, :stand2 => 3..3, :walkleft => 1..2, :walkright => 4..5,
                               :blink1 => 6..6, :blink2 => 7..7 }    # Designate frame_names ranges
    @frame_name = :stand1     # Start out by animation contained in @animation[:stand1]    
    @last_x, @last_y = @x, @y
    @dir = -1
    @cooling_down = false
    @second_pl = false
  end

  def meow
    return if @cooling_down
    @cooling_down = true
    after(250) { @cooling_down = false }
    if rand(3) == 1
      Sound["../media/sounds/meow1.wav"].play(0.4)
    else
      if rand(2) == 1
        Sound["../media/sounds/meow2.wav"].play(0.4)
      else
        Sound["../media/sounds/meow3.wav"].play(0.3)
      end
    end
  end

  def second_player
    if @second_pl == false
      Player2.create(:x => $window.width/3*2, :y => $window.height/2)
      @second_pl = true
    else
      Player2.destroy_all
      @second_pl = false
    end
  end

  def left
    @x -= 8
    @frame_name = :walkleft
    @dir = -1
  end
  def right
    @x += 8
    @frame_name = :walkright
    @dir = 1
  end
  def up
    @y -= 8
    if @dir == -1
      @frame_name = :walkleft
    else
      @frame_name = :walkright
    end
  end
  def down
    @y += 8
    if @dir == -1
      @frame_name = :walkleft
    else
      @frame_name = :walkright
    end
  end

  def update
    @image = @animation[@frame_name].next       # Move the animation forward by fetching the next frame and putting it into @image    
    if @x == @last_x && @y == @last_y      # If Cat stands still, use the blink animation
      if @dir == 1
        @frame_name = (milliseconds / 140 % 15 == 0) ? :blink2 : :stand2
      else
        @frame_name = (milliseconds / 140 % 15 == 0) ? :blink1 : :stand1
      end
    end

    if @x < -65     # wrap around beyond screen edges
      @x = 965
    end
    if @y < -60
      @y = 750
    end
    if @x > 965
      @x = -65
    end
    if @y > 750
      @y = -60
    end

    @last_x, @last_y = @x, @y     # save current coordinates for possible use next time
  end
end



#
#   PLAYER2 CLASS
#     2nd Player Class
#
class Player2 < Chingu::GameObject
  traits :timer
 
  def initialize(window)
    super
    self.input = { :holding_a => :left, :holding_d => :right, :holding_w => :up, :holding_s => :down  }
    @animation = Chingu::Animation.new(:file => "../media/plyr2.png", :center_x => 500, :center_y => 500, :delay => 70)
    @animation.frame_names = { :stand1 => 0..0, :stand2 => 3..3, :walkleft => 1..2, :walkright => 4..5,
                               :blink1 => 6..6, :blink2 => 7..7 }
    @frame_name = :stand1    
    @last_x, @last_y = @x, @y
    @dir = 1
    update
  end

  def left
    @x -= 8
    @frame_name = :walkleft
    @dir = -1
  end
  def right
    @x += 8
    @frame_name = :walkright
    @dir = 1
  end
  def up
    @y -= 8
    if @dir == -1
      @frame_name = :walkleft
    else
      @frame_name = :walkright
    end
  end
  def down
    @y += 8
    if @dir == -1
      @frame_name = :walkleft
    else
      @frame_name = :walkright
    end
  end

  def update    
    @image = @animation[@frame_name].next
    if @x == @last_x && @y == @last_y       # blinks when standing still
      if @dir == 1
        @frame_name = (milliseconds / 220 % 16 == 0) ? :blink2 : :stand2
      else
        @frame_name = (milliseconds / 220 % 16 == 0) ? :blink1 : :stand1
      end
    end
    if @x < -65      # wrap around beyond screen edges
      @x = 965
    end
    if @y < -60
      @y = 750
    end
    if @x > 965
      @x = -65
    end
    if @y > 750
      @y = -60
    end
    @last_x, @last_y = @x, @y    # save current coordinates
  end
end
