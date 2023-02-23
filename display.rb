class Game

  attr_accessor :guesser, :maker, :feedback

  def initialize
    puts "Welcome to Mastermind! In this game, you will play against a computer to either guess their code,
    or have the computer guess your code!"
    input
    @feedback = []
    play
  end

  private

  def input
    puts 'Enter 1 to be the code guesser or 2 to be the code maker'
    choice = gets.chomp
    if choice == '1'
      self.guesser = CodeGuesser.new(1); self.maker = CodeMaker.new(0)
    elsif choice == '2'
      self.maker = CodeMaker.new(1); self.guesser = CodeGuesser.new(0)
    else
      puts 'Enter 1 or 2!'; input
    end
  end

  def play
    maker.maker.zero? ? human_turns : computer_turns
  end

  def human_turns
    while maker.solved == false && guesser.turns < 12
      p "Guess number #{guesser.turns}. Enter your guess like so: 1,1,1,1"
      guess = gets.chomp.split(',').map(&:to_i)
      feedback_update(guess)
      end_human_turn
    end
  end

  def feedback_update(guess)
    self.feedback = []
    guesser.turns += 1
    guess.each_with_index do |n, i|
      if n == maker.code[i]
        feedback << n
      elsif maker.code.include?(guess[i])
        feedback.push('X')
      else
        feedback.push('O')
      end
    end
  end
  
  def end_human_turn
    p feedback
    if feedback == maker.code
      maker.solved = true
      p 'Congratulations! You guessed it!'
      play_again
    end
    if guesser.turns == 12 && !maker.solved
      p "Looks like you didn't get it!" 
      play_again
    end
  end

  def computer_turns
    guess = Array.new(4)
    while maker.solved == false && guesser.turns < 12
      guess.each_with_index do |_v, i|
        guess[i] == maker.code[i] ? guess[i] : guess[i] = rand(1..9)
      end
      comp_guess_update(guess)
    end
    return unless guesser.turns == 12 && feedback != maker.code
    p 'Nice job! The computer failed!'
    play_again
  end

  def comp_guess_update(guess)
    guesser.turns += 1
    p "Guess number #{guesser.turns}. The computer guessed #{guess}"
    sleep(1)
    end_computer_turn(guess)
  end

  def end_computer_turn(guess)
    return unless guess == maker.code
    maker.solved = true
    p 'The computer guessed it!!'
    play_again
  end

  def play_again
    p "Play again? Type Y or N"
    answer = gets.chomp
    answer == 'Y' ? Game.new : return
  end
end

class CodeGuesser
  attr_accessor :guesser, :turns

  def initialize(guesser)
    @guesser = guesser
    @turns = 0
    startup
  end

  private

  def startup
    p 'You are a guesser! You will have 12 chances to guess the computer\'s code.' if guesser == 1
  end
end

class CodeMaker
  attr_accessor :maker, :code, :solved

  def initialize(maker)
    @maker = maker
    @code = nil
    @solved = false
    startup
  end

  def startup
    if maker == 1
      p "You are a maker! You will think of a code and the computer will get 12 chances to guess it. After each guess,
      you will get feedback on how close your guess was. A number means you guessed the correct number in the
      correct spot. An 'X' means that number is somewhere in the code, but you guessed the wrong spot. An 'O'
      means the number is not in the code at all"
    end
    generate_code
  end

  private

  def generate_code
    if maker.zero?
      self.code = [rand(1..9), rand(1..9), rand(1..9), rand(1..9)]
    else
      puts 'Enter 4 single digit numbers separated by a comma to make as your code'
      self.code = gets.chomp.split(',').map(&:to_i)
    end
  end
end

game = Game.new
