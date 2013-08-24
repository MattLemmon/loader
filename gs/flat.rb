#
#  Flatulence Class
#
class Flat < Chingu::GameObject
	def setup
    @strength = 0.1*(rand(10) + 1)
    @flength = @strength * 40 - 2
    char = ["@","$","%","&","!","?",".","*","<","@","$","%","&","!","?",".","*",">","~","`"]
    @flat = Array.new(@flength){[*'0'..'9', *'a'..'z', *'A'..'Z', *char].sample}.join
    c = rand(9)
    @f = char[c]
    puts @flat + @f
    if @strength <= 0.3
      Sound["../media/sounds/fart1.ogg"].play(0.3)
    else
    	if @strength <= 0.5
        Sound["../media/sounds/fart2.ogg"].play(@strength)
      else
      	if @strength <= 0.6
          Sound["../media/sounds/fart1.ogg"].play(@strength)
        else
        	if @strength <= 0.7
            Sound["../media/sounds/fart2.ogg"].play(@strength)
          else
          	if @strength <= 0.9
              Sound["../media/sounds/fart3.ogg"].play(@strength)
            else
            	Sound["../media/sounds/fart6.ogg"].play(@strength)
            end
          end
        end
      end
    end
  end
end

# Alternate flatulence algorithms:
#   1
#    puts rand(36**@flength).to_s(36)
#   2
#    f =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
#    @flat  =  (0...50).map{ f[rand(f.length)] }.join