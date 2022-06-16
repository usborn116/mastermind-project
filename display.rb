class Game
  attr_accessor :guesser, :maker, :code_to_break, :feedback

  def initialize
    puts "Welcome to Mastermind! In this game, you will play against a computer to either guess their code,
    or have the computer guess your code!"
  end

  def input
    input = ''
    until input == '1' || input == '2'
      puts 'Enter 1 to be the code guesser, and 2 to be the code maker'
      input = gets.chomp
    end
    if input == '1'
      $human = CodeGuesser.new(1)
      $comp = CodeMaker.new(0)
    else
      $human = CodeMaker.new(1)
      $comp = CodeGuesser.new(0)
    end
  end

  def play
    if defined?($comp.code)
      @code_to_break = $comp.code
      comp_makes_code
    else
      @code_to_break = $human.code
      human_makes_code
    end
    p code_to_break
  end

  def comp_makes_code
    solved = false
    turns = 0
    p 'You will have 12 chances to guess the computer\'s code. After each guess, you will get feedback on how close your
    guess was. A number means you guessed the correct number in the correct spot. An "X" means that number is somewhere
    in the code, but you guessed the wrong spot. An "O" means the number is not in the code at all'
    while solved == false && turns < 12
      p 'Enter your guess in this format: 1,1,1,1'
      guess = gets.chomp.split(',').map { |n| n.to_i }
      @feedback = []
      guess.each_with_index do |_v, i|
        if guess[i] == code_to_break[i]
          @feedback.push(guess[i])
        elsif code_to_break.include?(guess[i])
          @feedback.push('X')
        else
          @feedback.push('O')
        end
      end
      turns += 1
      p feedback
      p "Guess number #{turns}"
      if feedback == code_to_break
        solved = true
        p 'Congratulations! You guessed it!'
        break
      end
    end
    return unless turns == 12 && feedback != code_to_break

    p "Looks like you didn't get it! Try again?"
  end

  def human_makes_code
    solved = false
    turns = 0
    guess = Array.new(4)
    while solved == false && turns < 12
      guess.each_with_index do |_v, i|
        if guess[i] == code_to_break[i]
          guess[i]
        else
          guess[i] = rand(1..9)
        end
      end
      turns += 1
      p "Guess number #{turns}"
      p "The computer guessed #{guess}"
      p guess
      p code_to_break
      sleep(1)
      if guess == code_to_break
        solved = true
        p 'The computer guessed it!!'
        break
      end
    end
    return unless turns == 12 && feedback != code_to_break

    p 'Nice job! The computer failed!'
  end
end

class CodeGuesser
  attr_accessor :guesser

  def initialize(guesser)
    @guesser = guesser
    startup
  end

  def startup
    return unless @guesser == 1

    p 'You are a guesser! You will have 12 chances to guess the computer\'s code.'
  end
end

class CodeMaker
  attr_accessor :maker, :code

  def initialize(maker)
    @maker = maker
    @code = ''
    startup
  end

  def startup
    if @maker == 1
      p 'You are a maker! You will think of a code and the computer will get 12 chances to guess it.'
    end
    generate_code
  end

  def generate_code
    if @maker.zero?
      @code = [rand(1..9), rand(1..9), rand(1..9), rand(1..9)]
    else
      puts 'Enter 4 single digit numbers separated by a comma to make as your code'
      @code = gets.chomp.split(',').map { |n| n.to_i }
    end
  end
end

game = Game.new
game.input
game.play
