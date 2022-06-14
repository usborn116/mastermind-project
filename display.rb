class Game
  attr_accessor :guesser, :maker

  def initialize
    puts "Welcome to Mastermind! In this game, you will play against a computer to either guess their code,
    or have the computer guess your code!"
  end

  def get_input
    input = ''
    until input == '1' || input == '2'
      puts 'Enter 1 to be the code guesser, and 2 to be the code maker'
      input = gets.chomp
    end
    if input == '1'
      human = CodeGuesser.new(1)
      comp = CodeMaker.new
    else 
      human = CodeMaker.new(1)
      comp = CodeGuesser.new
    end
  end
end

class CodeGuesser
  attr_accessor :guesser

  def initialize(guesser = 0)
    @guesser = guesser
    startup
  end

  def startup
    if @guesser == 1
      p 'You are a guesser! You will have 12 chances to guess the computer\'s code.'
    end
  end

end

class CodeMaker
  attr_accessor :maker

  def initialize(maker = 0)
    @maker = maker
    startup
  end

  def startup
    if @maker == 1
      p 'You are a maker! You will think of a code and the computer will get 12 chances to guess it.'
    end
    generate_code
  end

  def generate_code
    if @maker == 0
      code = [rand(1..9),rand(1..9),rand(1..9),rand(1..9)]
      p code
    else
      puts "Enter 4 single digit numbers separated by a comma to make as your code"
      code = gets.chomp.split(',').map{|n| n.to_i}
      p code
    end
  end
end

game = Game.new
game.get_input
