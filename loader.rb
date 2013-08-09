$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "gs")

require 'chingu'
require 'gosu'
require 'texplay'
include Chingu
include Gosu
                        #  Classes:
require 'CORE'          #    Loader, Pause, Welcome
require 'balls'         #    Bowl, FireCube, Splash, Circle, Box
require 'droid'         #    DoridGame, Droid, Bullet
require 'jungle'        #    Scroller, Jungle
require 'plasma'        #    Plasmoids, Plasma
require 'pond'          #    Pond, Fish
require 'cat'           #    Cat, Gato, Player2
require 'zoom'          #    Zoom,  Starship,  Star
require 'battle'        #    CityBattle, Airplane, Missile, EnemyBullet, Explosion, Shrapnel, Enemy, Gameover, Done
require 'sandbox'       #    SandBox,  Explorer
require 'ex7'           #    ParticleDisplay, Fill, FillRect, FillGrdnt, FillGrdntMultClrs, FillGrdntRect
require 'game_of_life'  #    GameOfLife

Loader.new.show
