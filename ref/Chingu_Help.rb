= CHINGU
http://github.com/ippa/chingu/tree/master

DOCUMENTATION: http://rdoc.info/projects/ippa/chingu

Ruby 1.9.2 is recommended. Should also work with 1.8.7+.
Chingu development is mostly conducted using Win7 / Ruby 1.9.2.


== DESCRIPTION
OpenGL accelerated 2D game framework for Ruby.
Builds on the awesome Gosu (Ruby/C++) which provides all the core functionality.
It adds simple yet powerful game states, pretty input handling, deployment safe asset-handling, a basic re-usable game object and automation of common task.


== INSTALL
  gem install chingu


== QUICK START (TRY OUT THE EXAMPLES)
Chingu comes with 25+ examples demonstrating various parts of Chingu. 
Please browse the examples-directory in the Chingu root directory.
The examples start out very simple. Watch out for instructions in the windows titlebar.
Could be how to move the onscreen player or how to move the example forward. Usually it's arrowkeys and space.
There's also more complex examples, like a clone of Conways game of life (http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) game_of_life.rb and example21_sidescroller_with_edit.rb where You can switch between playing and editing the level itself.

== PROJECTS USING CHINGU
Links to some of the projects using/depending on Chingu:
* http://ippa.se/games/unexpected_outcome.zip (LD#19 game compo entry by ippa)
* https://bitbucket.org/philomory/ld19/ (LD#19 game compo entry by philomory)
* https://github.com/Spooner/fidgit  (GUI-lib )
* https://github.com/Spooner/sidney  (Sleep Is Death remake in ruby)
* https://github.com/ippa/the_light_at_the_end_of_the_tunnel (LD#16 game compo entry)
* https://github.com/ippa/gnorf  (LD#18 game compo entry. Decent minigame with online highscores.)
* https://github.com/ippa/holiday_droid  (Work in progess platformer)
* https://github.com/ippa/pixel_pang  (Work in progress remake of the classic Pang)
* https://github.com/ippa/whygone  (An odd little platformer-puzzle-game for _why day)
* https://github.com/erisdiscord/gosu-tmx  (a TMX map loader)
* https://github.com/rkachowski/tmxtilemap  (Another TMX-class)
* https://github.com/erisdiscord/gosu-ring  (Secret of Mana-style ring menu for chingu/gosu)
* https://github.com/deps/Berzerk  (remake of the classic game. comes with robots.)
* https://github.com/rkachowski/tigjamuk10  ("sillyness from tigjamuk - CB2 bistro in Cambridge, January 2010")
* https://github.com/zukunftsalick/ruby-raid  (Remake of Ataris river raid, unsure of status)
* https://github.com/edward/spacewar  (a small game, unsure of status)
* https://github.com/jstorimer/zig-zag  (2D scrolling game, unsure of status)

... miss your Chingu project? Msg me on github and I'll add it to the list!

== THE STORY
The last years I've dabbled around a lot with game development.
I've developed games in both Rubygame and Gosu. I've looked at gamebox.
Rubygame is a very capable framework with a lot of functionality (collision detection, very good event system etc). Gosu is way more minimalistic but also faster with OpenGL -acceleration. Gosu isn't likely to get much more complex since it does what it should do very well and fast.

After 10+ game prototypes and some finished smaller games I started to see patterns each time I started a new game. Making classes with x/y/image/other-parameters that I called update/draw on in the main loop. 
This became the basic Chingu::GameObject which encapsulates Gosus "Image.draw_rot" and enables automatic updating/drawing through "game_objects".

There was always a huge big chunk of checking keyboard-events in the main loop.
Borrowing ideas from Rubygame this has now become @player.keyboard(:left => :move_left, :space => :fire ... etc.


== CORE OVERVIEW
Chingu consists of the following core classes / concepts:

=== Chingu::Window
The main window, use it at you use Gosu::Window now. Calculates the framerate, takes care of states, 
handles chingu-formated input, updates and draws BasicGameObject / GameObjects automatically.
Available throughout your source as $window (Yes, that's the only global Chingu has).
You can also set various global settings. For example, self.factor=3, will make all fortcomming GameObjects scale 3 times.

=== Chingu::GameObject
Use this for all your in game objects. The player, the enemies, the bullets, the powerups, the loot laying around.
It's very reusable and doesn't contain any game-logic (that's up to you!). Only stuff to put it on screen a certain way.
If you do GameObject.create() instead of new() Chingu will keep save the object in the "game_object"-list for automatic updates/draws.
GameObjects also have the nicer Chingu input-mapping: @player.input = { :left => :move_left, :right => :move_right, :space => :fire}
Has either Chingu::Window or a Chingu::GameState as "parent".

=== Chingu::BasicGameObject
For those who think GameObject is a too little fat, there's BasicGameObject (GameObject inherits from BasicGameObject).
BasicGameObject is just an empty frame (no x,y,image accessors or draw-logic) for you to build on.
It _can_ be extended with Chingus trait-system though. The new() vs create() behavior of GameObject comes from BasicGameObject.
BasicGameObject#parent points to either $window or a game state and is automatically set on creation time.

=== Chingu::GameStateManager
Keeps track of the game states. Implements a stack-based system with push_game_state and pop_game_state.

=== Chingu::GameState
A "standalone game loop" that can be activated and deactivated to control game flow.
A game state is very much like a main gosu window. You define update() and draw() in a gamestate.
It comes with 2 extras that main window doesn't have. #setup (called when activated) and #finalize (called when deactivated)

If using game states, the flow of draw/update/button_up/button_down is:
Chingu::Window --> Chingu::GameStateManager --> Chingu::GameState.
For example, inside game state Menu you call push_game_state(Level). When Level exists, it will go back to Menu.

=== Traits
Traits are extensions (or plugins if you so will) to BasicGameObjects included on the class-level.
The aim is so encapsulate common behavior into modules for easy inclusion in your game classes.
Making a trait is easy, just an ordinary module with the methods setup_trait(), update_trait() and/or draw_trait().
It currently has to be namespaced to Chingu::Traits for "traits" to work inside GameObject-classes.

== OTHER CLASSES / HELPERS

=== Chingu::Text
Makes use of Image#from_text more rubyish and powerful.
In it's core, another Chingu::GameObject + image genning with Image#from_text.

=== Chingu::Animation
Load and interact with tile-based animations. loop, bounce and access invidual frame(s) easily.
An "@image = @animation.next" in your Player#update is usually enough to get you started!

=== Chingu::Parallax
A class for easy parallaxscrolling. Add layers with different damping, move the camera to generate a new snapshot. See example3.rb for more.

=== Chingu::HighScoreList
A class to keep track of high scores, limit the list, automatic sorting on score, save/load to disc. See example13.rb for more.

=== Chingu::OnlineHighScoreList
A class to keep/sync online highscores to http://gamercv.com/. A lot more fun competing with others for positions then a local list.

=== Various Helpers
Both $window and game states gets some new graphical helpers, currently only 3, but quite useful:

  fill()          # Fills whole window with color 'color'.
  fill_rect()     # Fills a given Rect 'rect' with Color 'color'
  fill_gradient() # Fills window or a given rect with a gradient between two colors.
  draw_circle()   # Draws a circle
  draw_rect()     # Draws a rect

If you base your models on GameObject (or BasicGameObject) you get:
  Enemy.all                 # Returns an Array of all Enemy-instances
  Enemy.size                # Returns the amount of Enemy-instances
  Enemy.destroy_all         # Destroys all Enemy-instances
  Enemy.destroy_if(&block)  # Destroy all objects for which &block returns true


== BASICS / EXAMPLES

=== Chingu::Window
With Gosu the main window inherits from Gosu::Window. In Chingu we use Chingu::Window. It's a basic Gosu::Window with extra cheese on top of it. keyboard handling, automatic update/draw calls to all gameobjects, fps counting etc.

You're probably familiar with this very common Gosu pattern:
  
  ROOT_PATH = File.dirname(File.expand_path(__FILE__))
  class Game < Gosu::Window
    def initialize
      @player = Player.new
    end
    
    def update
      if button_down? Button::KbLeft
        @player.left
      elsif button_down? Button::KbRight
        @player.right
      end
      
      @player.update      
    end
    
    def draw
      @player.draw
    end
  end
  
  class Player
    attr_accessor :x,:y,:image
    def initialize(options)
      @x = options[:x]
      @y = options[:y]
      @image = Image.new(File.join(ROOT_PATH, "media", "player.png"))
    end
    
    def move_left
      @x -= 1
    end
    
    def move_right
      @x += 1
    end
    
    def draw
      @image.draw(@x,@y,100)
    end
  end
  
  Game.new.show   # Start the Game update/draw loop!


Chingu doesn't change the fundamental concept/flow of Gosu, but it will make the above code shorter:
  
  #
  # We use Chingu::Window instead of Gosu::Window
  #
  class Game < Chingu::Window
    def initialize
      super       # This is always needed if you override Window#initialize
      #
      # Player will automatically be updated and drawn since it's a Chingu::GameObject
      # You'll need your own Chingu::Window#update and Chingu::Window#draw after a while, but just put #super there and Chingu can do its thing.
      #
      @player = Player.create
      @player.input = {:left => :move_left, :right => :move_right}
    end    
  end
    
  #
  # If we create classes from Chingu::GameObject we get stuff for free.
  # The accessors image,x,y,zorder,angle,factor_x,factor_y,center_x,center_y,mode,alpha.
  # We also get a default #draw which draws the image to screen with the parameters listed above.
  # You might recognize those from #draw_rot - http://www.libgosu.org/rdoc/classes/Gosu/Image.html#M000023
  # And in it's core, that's what Chingu::GameObject is, an encapsulation of draw_rot with some extras.
  # For example, we get automatic calls to draw/update with Chingu::GameObject, which usually is what you want. 
  # You could stop this by doing: @player = Player.new(:draw => false, :update => false)
  #
  class Player < Chingu::GameObject
    def initialize(options)
      super(options.merge(:image => Image["player.png"])
    end
    
    def move_left
      @x -= 1
    end
    
    def move_right
      @x += 1
    end    
  end

  Game.new.show   # Start the Game update/draw loop!
  
Roughly 50 lines became 26 more powerful lines. (you can do @player.angle = 100 for example)

If you've worked with Gosu for a while you're probably tired of passing around the window-parameter.
Chingu solves this (as has many other developers) with a global variable $window. Yes, globals are bad, but in this case it kinda makes sense. It's used under the hood in various places.

The basic flow of Chingu::Window once show() is called is this (this is called one game iteration or game loop):
  
  - Chingu::Window#draw() is called
  -- draw() is called on game objects belonging to Chingu::Window
  -- draw() is called on all game objects belonging to current game state
  
  - Chingu::Window#update() is called
  -- Input for Chingu::Window is processed
  -- Input for all game objects belonging to Chingu::Window is processed
  -- update() is called on all game objects belonging to Chingu::Window
  -- Input for current game state is processed
  -- Input for game objects belonging to current game state is processed
  -- update() is called on all game objects belonging to current game state

... the above is repeatet until game exists.
  
=== Chingu::GameObject
This is our basic "game unit"-class, meaning most in game objects (players, enemies, bullets etc) should be inherited from Chingu::GameObject.
The basic ideas behind it are:

* Encapsulate only the very common basics that Most in game objects need
* Keep naming close to Gosu, but add smart convenient methods / shortcuts and a more rubyish feeling
* No game logic allowed in GameObject, since that's not likely to be useful for others.

It's based around Image#draw_rot. So basically all the arguments that you pass to draw_rot can be passed to GameObject#new when creating a new object.
An example using almost all arguments would be:
  
  #
  # You probably recognize the arguments from http://www.libgosu.org/rdoc/classes/Gosu/Image.html#M000023
  #
  @player = Player.new(:image => Image["player.png"], :x=>100, :y=>100, :zorder=>100, :angle=>45, :factor_x=>10, :factor_y=>10, :center_x=>0, :center_y=>0)
  
  #
  # A shortcut for the above line would be
  #
  @player = Player.new(:image => "player.png", :x=>100, :y=>100, :zorder=>100, :angle=>45, :factor=>10, :center=>0)

  #
  # I've tried doing sensible defaults:
  # x/y = [middle of the screen]  for super quick display where it should be easy in sight)
  # angle = 0                     (no angle by default)
  # center_x/center_y = 0.5       (basically the center of the image will be drawn at x/y)
  # factor_x/factor_y = 1         (no zoom by default)
  # 
  @player = Player.new
  
  #
  # By default Chingu::Window calls update & draw on all GameObjects in it's own update/draw.
  # If this is not what you want, use :draw and :update
  #
  @player = Player.new(:draw => false, :update => false)

=== Input
One of the core things I wanted a more natural way of inputhandling.
You can define input -> actions on Chingu::Window, Chingu::GameState and Chingu::GameObject.
Like this:

  #
  # When left arrow is pressed, call @player.turn_left ... and so on.
  #
  @player.input = { :left => :turn_left, :right => :turn_right, :left => :halt_left, :right => :halt_right }

  
  #
  # In Gosu the equivalent would be:
  #
  def button_down(id)
    @player.turn_left		if id == Button::KbLeft
    @player.turn_right	if id == Button::KbRight
  end
  
  def button_up(id)
    @player.halt_left		if id == Button::KbLeft
    @player.halt_right	if id == Button::KbRight
  end


Another more complex example:

  #
  # So what happens here?
  #
  # Pressing P would create an game state out of class Pause, cache it and activate it.
  # Pressing ESC would call Play#close
  # Holding down LEFT would call Play#move_left on every game iteration
  # Holding down RIGHT would call Play#move_right on every game iteration
  # Releasing SPACE would call Play#fire
  #
  
  class Play < Chingu::GameState
    def initialize
      self.input = { :p => Pause, 
                     :escape => :close, 
                     :holding_left => :move_left, 
                     :holding_right => :move_right, 
                     :released_space => :fire }
    end
  end
  class Pause < Chingu::GameState
    # pause logic here
  end

In Gosu the above code would include code in button_up(), button_down() and a check for button_down?() in update().

Every symbol can be prefixed by either "released_" or "holding_" while no prefix at all defaults to pressed once.

So, why not :up_space or :release_space instead of :released_space?
+:up_space+ doesn't sound like english, :release_space sounds more like a command then an event.


Or +:hold_left+ or :down_left instead of :holding_left?
:holding_left sounds like something that's happening over a period of time, not a single trigger, which corresponds well to how it works.

And with the default :space => :something you would imagine that :something is called once. You press :space once, :something is executed once.


=== GameState / GameStateManager
Chingu incorporates a basic push/pop game state system (as discussed here: http://www.gamedev.net/community/forums/topic.asp?topic_id=477320).

Game states is a way of organizing your intros, menus, levels.

Game states aren't complicated. In Chingu a GameState is a class that behaves mostly like your default Gosu::Window (or in our case Chingu::Window) game loop.

  
  # A simple GameState-example
  class Intro < Chingu::GameState
  
    def initialize(options)
      # called as usual when class is created, load resources and simular here
    end
  
    def update
      # game logic here
    end
    
    def draw
      # screen manipulation here
    end
        
    # Called Each time when we enter the game state, use this to reset the gamestate to a "virgin state"
    def setup
      @player.angle = 0   # point player upwards
    end
    
    # Called when we leave the game state
    def finalize
      push_game_state(Menu)   # switch to game state "Menu"
    end

  end

Looks familiar yet?
You can activate the above game state in 2 ways

  class Game < Chingu::Window
    def initialize
      #
      # 1) Create a new Intro-object and activate it (pushing to the top).
      # This version makes more sense if you want to pass parameters to the gamestate, for example:
      # push_game_state(Level.new(:level_nr => 10))
      #
      push_game_state(Intro.new)
      
      #
      # 2) This leaves the actual object-creation to the game state manager.
      # Intro#initialize() is called, then Intro#setup()
      #
      push_game_state(Intro)
    end
  end

Another example:

  class Game < Chingu::Window
    def initialize
      #
      # We start by pushing Menu to the game state stack, making it active as the only state on stack.
      # :setup => :false which will skip setup() from being called (standard when switching to a new state)
      #
      push_game_state(Menu, :setup => false)
      
      #
      # We push another game state to the stack, Play. We now have 2 states, which active being first / active.
      #
      # :finalize => false will skip setup() from being called on game state 
      # that's being pushed down the stack, in this case Intro.setup().
      #
      push_game_state(Play, :finalize => false)
    
      #
      # This would remove Play state from the stack, going back to the Menu-state. But also:
      # .. skipping the standard call to Menu#setup     (the new game state)
      # .. skipping the standard call to Play#finalize  (the current game state)
      #
      # :setup => false can for example be useful when pop'ing a Pause game state. (see example4.rb)
      #
      pop_game_state(:setup => false, :finalize => :false)
      
      #
      # Replace the current game state with a new one.
      # :setup and :finalize options are available here as well.
      #
      switch_game_state(Credits)
    end
  end
  
A GameState in Chingu is just a class with the following instance methods: 

* initialize()    - as you might expect, called when GameState is created.
* setup()         - called each time the game state becomes active.
* button_down(id) - called when a button is down.
* button_up(id)   - called when a button is released.
* update()        - just as in your normal game loop, put your game logic here.
* draw()          - just as in your normal game loop, put your screen manipulation here.
* finalize()      - called when a game state de-activated (for example by pushing a new one on top with push_game_state)

Chingu::Window automatically creates a @game_state_manager and makes it accessible in our game loop.
By default the game loop calls update() / draw() on the the current game state.

Chingu also has a couple of helpers-methods for handling the game states:
In a main loop or in a game state:
* push_game_state(state)        - adds a new gamestate on top of the stack, which then becomes the active one
* pop_game_state                - removes active gamestate and activates the previous one
* switch_game_state(state)      - replaces current game state with a new one
* current_game_state            - returns the current game state
* previous_game_state           - returns the previous game state (useful for pausing and dialog boxes, see example4.rb)
* pop_until_game_state(state)   - pop game states until given state is found
* clear_game_states             - removes all game states from stack

To switch to a certain gamestate with a keypress use Chingus input handler:
  class Intro < Chingu::GameState
    def setup
      self.input = { :space => lambda{push_gamestate(Menu.new)} }
    end
  end
  
Or Chingus shortcut:

  class Intro < Chingu::GameState
    def setup
      self.input = { :space => Menu }
    end
  end
  
Chingus inputhandler will detect that Menu is a GameState-class, create a new instance and activate it with push_game_state().

=== Premade game states
Chingu comes with some pre-made game states.
A simple but usefull one is GameStates::Pause. Once pushed it will draw the previous game state but not update it --
effectively pausing it. Some others are:

== GameStates::EnterName
A gamestate where a gamer can select letters from a A-Z list, contructing his alias. When he's done he selects "GO!" and a 
developer-specified callback will be called with the name/alias as argument.

  push_game_state GameStates::EnterName.new(:callback => method(:add))
  
  def add(name)
    puts "User entered name #{name}"
  end

Combine GameStates::EnterName with class OnlineHighScoreList, a free acount @ www.gamercv.com and you have a premade stack to 
provide your 48h gamecompo entry with online high scores that adds an extra dimension to your game. See example16 for a full working example of this.


== GameStates::Edit
The biggest and most usable is GameStates::Edit which enables fast 'n easy level-building with game objects.
Start example19 and press 'E' to get a full example.

Edit commands / shortcuts:
  F1: Help screen
  1-5: create object 1..5 shown in toolbar at mousecursor
  CTRL+A: select all objects (not in-code-created ones though)
  CTRL+S: Save
  E: Save and Quit
  Q: Quit (without saving)
  ESC: Deselect all objects
  Right Mouse Button Click: Copy object bellow cursor for fast duplication
  Arrow-keys (with selected objects): Move objects 1 pixel at the time
  Arrow-keys (with no selected objects): Scroll within a viewport
  

  Bellow keys operates on all currently selected game objects
  -----------------------------------------------------------------------------------
  DEL: delete selected objects
  BACKSPACE: reset angle and scale to default values
  Page Up: Increase zorder
  Page Down: Decrease zorder
  
  R: scale up
  F: scale down
  T: tilt left
  G: tilt right
  Y: inc zorder
  H: dec zorder
  U: less transparency
  J: more transparency

  Mouse Wheel (with no selected objects): Scroll viewport up/down
  Mouse Wheel: Scale up/down
  SHIFT + Mouse Wheel: Tilt left/right
  CTRL + Mouse Wheel: Zorder up/down
  ALT + Mouse Wheel: Transparency less/more
  
Move mouse cursor close to the window border to scroll a viewport if your game state has one.

If you're editing game state BigBossLevel the editor will save to big_boss_level.yml by default.
All the game objects in that file are then easily loaded with the load_game_objects command.

Both Edit.new and load_game_objects take parameters as 
  :file => "enemies.yml"    # Save edited game objects to file enemies.yml
  :debug => true            # Will print various debugmsgs to console, usefull if something behaves oddly
  :except => Player         # Don't edit or load objects based on class Player

=== WorkFlow
(This text is under development)

== The setup-method
If a setup() is available in a instance of Chingu::GameObject, Chingu::Window and Chingu::GameState it will automatically be called.
This is the perfect spot to include various setup/init-tasks like setting colors or loading animations (if you're not using the animation-trait).
You could also override initialize() for this purpose but it's been proven prone to errors again and again.
Compare the 2 snippets below:

  # Easy to mess up, forgetting options or super
  def initialize(options = {})
    super
    @color = Color::WHITE
  end
  
  # Less code, easier to get right and works in GameObject, Window and GameState
  # Feel free to call setup() anytime, there's no magic about ut except it's autocalled once on object creation time.
  def setup
    @color = Color::WHITE
  end
  
=== Traits
Traits (sometimes called behaviors in other frameworks) is a way of adding logic to any class inheriting from BasicGameObject / GameObject.
Chingus trait-implementation is just ordinary ruby modules with 3 special methods:
 - setup_trait 
 - update_trait 
 - draw_trait
Each of those 3 methods must call "super" to continue the trait-chain.

Inside a certian trait-module you can also have a module called ClassMethods, methods inside that module will be added,
yes you guessed it, as class methods. If initialize_trait is defined inside ClassMethods it will be called class-evaluation time
(basicly on the trait :some_trait line).

A simple trait could be:

  module Chingu
    module Trait
      module Inspect
    
        #
        # methods namespaced to ClassMethods get's extended as ... class methods!
        #
        module ClassMethods
          def initialize_trait(options)
            # possible initialize stuff here
          end
        
          def inspect
            "There's {self.size} active instances of class {self.to_s}"
          end
        end
      
        #
        # Since it's namespaced outside ClassMethods it becomes a normal instance-method
        #
        def inspect
          "Hello I'm an #{self.class.to_s}"
        end
        
        #
        # setup_trait is called when a object is created from a class that included the trait
        # you most likely want to put all the traits settings and option parsing here
        #
        def setup_trait(options)
          @long_inspect = true
        end
      
      end
    end
  end

  class Enemy < GameObject
    trait :inspect    # includes Chingu::Trait::Inspect and extends Chingu::Trait::Inspect::ClassMethods
  end
  10.times { Enemy.create }
  Enemy.inspect           # => "There's 10 active instances of class Enemy"
  Enemy.all.first.inspect # => "Hello I'm a Enemy"


Example of using traits :velocity and :timer.
We also use GameObject#setup which will automtically be called ad the end of GameObject#initialize.
It's often a little bit cleaner to use setup() then to override initialize().

  class Ogre < Chingu::GameObject
    traits :velocity, :timer

    def setup
      @red = Gosu::Color.new(0xFFFF0000)
      @white = Gosu::Color.new(0xFFFFFFFF)
      
      #
      # some basic physics provided by the velocity-trait
      # These 2 parameters will affect @x and @y every game-iteration
      # So if your ogre is standing on the ground, make sure you cancel out the effect of @acceleration_y
      #
      self.velocity_x = 1       # move constantly to the right
      self.acceleration_y = 0.4 # gravity is basicly a downwards acceleration
    end
    
    def hit_by(object)
      #
      # during() and then() is provided by the timer-trait
      # flash red for 300 millisec when hit, then go back to normal
      #
      during(100) { self.color = @red; self.mode = :additive }.then { self.color = @white; self.mode = :default }
    end
  end
  
The flow for a game object then becomes:

  -- creating a GameObject class X  ( with a "trait :bounding_box, :scale => 0.80" )
  1) trait gets merged into X, instance and class methods are added
  2) GameObject.initialize_trait(:scale => 0.80)   (initialize_trait is a class-method!)
  -- creating an instance of X
  1) GameObject#initialize(options)
  2) GameObject#setup_trait(options)
  3) GameObject#setup(options)
  -- each game iteration
  3) GameObject#draw_trait
  4) GameObject#draw
  5) GameObject#update_trait
  6) GameObject#update

There's a couple of traits included as default in Chingu:

==== Trait "sprite"
This trait fuels GameObject. A GameObject is a BasicGameObject + the sprite-trait.
Adds accessors :x, :y, :angle, :factor_x, :factor_y, :center_x, :center_y, :zorder, :mode, :visible, :color.
See documentation for GameObject for how it works.

==== Trait "timer"
Adds timer functionality to your game object
  during(300) { self.color = Color.new(0xFFFFFFFF) }  # forces @color to white every update for 300 ms
  after(400) { self.destroy }                         # destroy object after 400 ms
  between(1000,2000) { self.angle += 10 }             # starting after 1 second, modify angleevery update during 1 second
  every(2000) { Sound["bleep.wav"].play }             # play bleep.wav every 2 seconds
  
==== Trait "velocity"
Adds accessors velocity_x, velocity_y, acceleration_x, acceleration_y, max_velocity to game object.
They modify x, y as you would expect. *speed / angle will come*

==== Trait "bounding_box"
Adds accessor 'bounding_box', which returns an instance of class Rect based on current image size,x,y,factor_x,factor_y,center_x,center_y
You can also scale the calculated rect with trait-options:

  # This would return a rect slightly smaller then the image. 
  # Make player think he's better @ dodging bullets then he really is ;)
  trait :bounding_box, :scale => 0.80 
  
  # Make the bounding box bigger then the image
  # :debug => true shows the actual box in red on the screen
  trait :bounding_box, :scale => 1.5, :debug => true
  
Inside your object you will also get a cache_bounding_box(). After that the bounding_box will be quicker but it will not longer adapt to size-changes.

==== Trait "bounding_circle"
Adds accessor 'radius', which returns a Fixnum based on current image size,factor_x and factor_y
You can also scale the calculated radius with trait-options:

  # This would return a radius slightly bigger then what initialize was calculated
  trait :bounding_circle, :scale => 1.10

  # :debug => true shows the actual circle in red on the screen
  trait :bounding_circle, :debug => true

Inside your object you will also get a cache_bounding_circle(). After that radius() will be quicker but it will not longer adapt to size-changes.

==== Trait "animation"
Automatically load animations depending on the class-name.
Useful when having a lot of simple classes thats mainpurpose is displaying an animation.
Assuming the below code is included in a class FireBall.

  #
  # If a fire_ball_10x10.png/bmp exists, it will be loaded as a tileanimation.
	# 10x10 would indicate the width and height of each tile so Chingu knows hows to cut it up into single frames.
  # The animation will then be available in animations[:default] as an Animation-instance.
  #
  # If more then 1 animation exist, they'll will be loaded at the same time, for example:
  # fire_ball_10x10_fly.png       # Will be available in animations[:fly] as an Animation-instance
  # fire_ball_10x10_explode.png   # Will be available in animations[:explode] as an Animation-instance
  # 
	# The below example will set the 200ms delay between each frame on all animations loaded.
  #
  trait :animation, :delay => 200

==== Trait "effect"
Adds accessors rotation_rate, fade_rate and scale_rate to game object.
They modify angle, alpha and factor_x/factor_y each update. Since this is pretty easy to do yourself this trait might be up for deprecation.

==== Trait "viewport"
A game state trait. Adds accessor *viewport*. Set viewport.x and viewport.y to.
Basically what viewport.x = 10 will do is draw all game objects 10 pixels to the left of their ordinary position.
Since the viewport has moved 10 pixels to the right, the game objects will be seen "moving" 10 pixels to the left.
This is great for scrolling games. You also have:

  viewport.game_area = [0,0,1000,400]   # Set scrolling limits, the effective game world if you so will
  viewport.center_around(object)        # Center viweport around an object which responds to x() and y()
  
  viewport.lag      = 0.95              # Set a lag-factor to use in combination with x_target / y_target
  viewport.x_target = 100               # This will move viewport towards X-coordinate 100, the speed is determined by the lag-parameter.

==== Trait "collision_detection"
Adds class and instance methods for basic collision detection.
  
  # Class method example
  # This will collide all Enemy-instances with all Bullet-instances using the attribute #radius from each object.
  Enemy.each_bounding_circle_collision(Bullet) do |enemy, bullet|
  end
  
  # You can also use the instance methods. This will use the Rect bounding_box from @player and each EnemyRocket-object.
  @player.each_bounding_box_collision(EnemyRocket) do |player, enemyrocket|
    player.die!
  end

  #
  # each_collision automatically tries to access #radius and #bounding_box to see what a certain game object provides
  # It knows how to collide radius/radius, bounding_box/bounding_box and radius/bounding_box !
  # Since You're not explicity telling what collision type to use it might be slighty slower.
  #
  [Player, PlayerBullet].each_collision(Enemy, EnemyBullet) do |friend, foe|
    # do something
  end
  
  #
  # You can also give each_collision() an array of objects.
  #
  Ball.each_collsion(@array_of_ground_items) do |ball, ground|
    # do something
  end
  
==== (IN DEVELOPMENT) Trait "retrofy"
Providing easier handling of the "retrofy" effect (non-blurry zoom)
Aims to help out when using zoom-factor to create a retrofeeling with big pixels.
Provides screen_x and screen_y which takes the zoom into account
Also provides new code for draw() which uses screen_x / screen_y instead of x / y



=== Assets / Paths

You might wonder why this is necessary in the straight Gosu example:
  ROOT_PATH = File.dirname(File.expand_path(__FILE__))
  @image = Image.new(File.join(ROOT_PATH, "media", "player.png"))

It enables you to start your game from any directory and it will still find your assets (pictures, samples, fonts etc..) correctly.
For a local development version this might not be important, you're likely to start the game from the games root-dir.
But as soon as you try to deploy (for example to windows with OCRA - http://github.com/larsch/ocra/tree/master) you'll run into trouble of you don't do it like that.
 
Chingu solves this problem behind the scenes for the most common assets. The 2 lines above can be replaced with:
  Image["player.png"]

You also have:
  Sound["shot.wav"]
  Song["intromusic.ogg"]
  Font["arial"]          
  Font["verdana", 16]     # 16 is the size of the font
  
The default settings are like this:
  Image["image.png"] -- searches directories ".", "images", "gfx" and "media"
  Sample["sample.wav"] -- searches directories ".", "sounds", "sfx" and "media"
  Song["song.ogg"] -- searches directories ".", "songs", "sounds", "sfx" and "media"
  Font["verdana"] -- searches directories ".", "fonts", "media"

Add your own searchpaths like this:
  Gosu::Image.autoload_dirs << File.join(ROOT, "gfx")
  Gosu::Sound.autoload_dirs << File.join(ROOT, "samples")

This will add \path\to\your\game\gfx and \path\to\your\game\samples  to Image and Sound.
  
Thanks to Jacious of rubygame-fame (http://rubygame.org/) for his named resource code powering this.

=== Text
Text is a class to give the use of Gosu::Font more rubyish feel and fit it better into Chingu.

# Pure Gosu
  @font = Gosu::Font.new($window, "verdana", 30)
  @font.draw("A Text", 200, 50, 55, 2.0)
  
# Chingu
  @text = Chingu::Text.create("A Text", :x => 200, :y => 50, :zorder => 55, :factor_x => 2.0)
  @text.draw

@text.draw is usually not needed as Text is a GameObject and therefore automatically updated/drawn (it #create is used instead of #new)
It's not only that the second example is readable by ppl now even familiar with Gosu, @text comes with a number of changeable properties, x,y,zorder,angle,factor_x,color,mode etc. 
Set a new x or angle or color and it will instantly update on screen.


== MISC / FAQ
=== How do I access my main-window easily?
Chingu keeps a global variable, $window, which contains the Chingu::Window instance. 
Since Chingu::Window is just Gosu::Window + some cheese you can do your $window.button_down?, $window.draw_line() etc from anywhere.
See http://www.libgosu.org/rdoc/classes/Gosu/Window.html for a full set of methods.

=== How did you decide on naming of methods / classes?
There's 1 zillion ways of naming stuff. As a general guideline I've tried to follow Gosus naming.
If Gosu didn't have a good name for a certain thing/method I've checked Ruby itself and then Rails since alot of Ruby-devs are familiar with Rails.
GameObject.all is naming straight from rails for example. Most stuff in GameObject follow the naming from Gosus Image#draw_rot.

As far as possible, use correct rubyfied english game_objects, not gameobjects. class HighScore, not Highscore.


== WHY?
* Plain Gosu is very minimalistic, perfect to build some higher level logic on!
* Deployment and asset handling should be simple
* Managing game states/scenes (intros, menus, levels etc) should be simple
* There are a lot patterns in game development

== OPINIONS
* Less code is usually better
* Hash arguments FTW. And it becomes even better in 1.9.
* Don't separate too much from Gosus core-naming

== CREDITS:
* Spooner (input-work, tests and various other patches)
* Jacob Huzak (sprite-trait, tests etc)
* Jacius of Rubygame (For doing cool stuff that's well documented as re-usable). So far rect.rb and named_resource.rb is straight outta Rubygame.
* Banister (of texplay fame) for general feedeback and help with ruby-internals and building the trait-system
* Jduff for input / commits
* Jlnr,Philomory,Shawn24,JamesKilton for constructive feedback/discussions
* Ariel Pillet for codesuggestions and cleanups
* Deps for making the first real full game with Chingu (and making it better in the process)
* Thanks to http://github.com/tarcieri for require_all code, good stuff
.. Did I forget anyone here? Msg me on github.

== REQUIREMENTS:
* Gosu, preferable the latest version
* Ruby 1.9.1+ or 1.8.7+
* gem 'texplay' for some bonus Image-pixel operations, not needed otherwise

== TODO - this list is Discontinued and no longer updated!
* add :padding and :align => :topleft etc to class Text
* (skip) rename Chingu::Window so 'include Chingu' and 'include Gosu' wont make Window collide
* (done) BasicObject vs GameObject vs ScreenObject => Became BasicGameObject and GameObject
* (50%) some kind of componentsystem for GameObject (which should be cleaned up)
* (done) scale <--> growth parameter. See trait "effect"
* (done) Enemy.all ... instead of game_objects_of_type(Enemy) ? could this be cool / understandable?
* (done) Don't call .update(time) with timeparameter, make time available thru other means when needed.
* (10% done) debug screen / game state.. check out shawn24's elite irb sollution :)
* (done) Complete the input-definitions with all possible inputs (keyboard, gamepad, mouse)!
* (done) Complete input-stuff with released-states etc
* (done) More gfx effects, for example: fade in/out to a specific color (black makes sense between levels).
* (posted request on forums) Summon good proven community gosu snippets into Chingu
* (done) Generate docs @ ippa.github.com-  http://rdoc.info/projects/ippa/chingu !
* (done) A good scene-manager to manage welcome screens, levels and game flow- GameStateManager / GameState !
* (20% done) make a playable simple game in examples\ that really depends on game states
* (done) Make a gem- first gem made on github
* (done) Automate gemgenning rake-task even more
* (done) More examples when effects are more complete
* class ChipmunkObject
* (done) class Actor/MovingActor with maybe a bit more logic then the basic GameObject.
* (60% done) Spell check all docs, sloppy spelling turns ppl off. tnx jduff ;).
* Tests
* (done) Streamline fps / tick code
* (done) Encapsulate Font.new / draw_rot with a "class Text < GameObject"
* (10% done) Make it possible for ppl to use the parts of Chingu they like
* (done) At least make GameStateManager really easy to use with pure Gosu / Document it!
* (50% done) Get better at styling rdocs
* (done) all �gamestate� ? �game state� ?   it's "game state"
* (skipping) intergrate MovieMaker - solve this with traits instead.
* A more robust game state <-> game_object system to connect them together.
* FIX example4: :p => Pause.new  would Change the "inside_game_state" to Pause and make @player belong to Pause.



  "If you program and want any longevity to your work, make a game. 
  All else recycles, but people rewrite architectures to keep games alive.", _why
  
  
