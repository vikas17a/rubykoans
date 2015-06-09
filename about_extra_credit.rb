# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.
#

class Game
  attr_reader :turn
  attr_reader :player1
  attr_reader :player2
  attr_reader :player #this is current player
  attr_reader :round
  attr_reader :last_score
  attr_reader :prev_nonscore
  

  def initialize
    @turn = 1
    @round = 0
    @last_score = 0
    @player1 = Player.new
    @player2 = Player.new
    @player = player1
    @prev_nonscore = -1

  end

  def play
    while play_more(@last_score)
      puts "Player #{@turn} is playing turn with #{@player.no_dice}"
      dice = DiceSet.roll(@player.no_dice)
      puts "Player #{@turn} has played dice #{dice}"
      @player.calculateScore(dice, @round)
      @round += 1
      puts "Player #{@turn} has scored #{@player.score}"
      @last_score = @player.score
      if (@player.no_dice > 0 || @player.score_dice  == 5) && (@prev_nonscore != @player.no_dice || @prev_nonscore == 0)
        @prev_nonscore = @player.no_dice
        puts "Player has #{@player.no_dice} non score dice"
        puts "Do you want to continue to roll ? {Y/N}"
        input = gets.chomp
        if input == 'Y'
          @round = 2    
          next
        end
      elsif @prev_nonscore == @player.no_dice
        @player.score -= @player.round_score
        if @player.score < 0
          @player.score = 0
        end
      end
      @player.reset_score
      @last_score = @player.score
      if @player.score < 300 && @player.open
        @player.score = 0
      elsif @player.score > 300
        @player.open = false
      end
      @player.dice_reset(5)
      if @player == @player1
        @player = @player2
      else
        @player = @player1
      end
      if @turn == 1
        @turn = 2
      else
        @turn = 1
      end
      @round = 0
      @prev_nonscore = -1
    end
    final_round
  end

  def final_round
    @player = @player1
    @turn = 1
    2.times do
      @player.dice_reset(5)
      @round = 0
      puts "Player #{@turn} is playing with #{@player.no_dice}"
      dice = DiceSet.roll(@player.no_dice)
      @player.calculateScore(dice, @round)
      @player = @player2
      @turn = 2
    end
    if @player1.score > @player2.score
      puts "Player 1 wins"
    else
      puts "Player 2 wins"
    end
  end

  def play_more(score)
    if score >= 400
      return false
    else
      return true
    end
  end
end

class Player
  attr_accessor :score
  attr_reader :no_dice
  attr_accessor :open
  attr_reader :round_score
  attr_reader :score_dice
  def initialize
    @score = 0
    @no_dice = 5
    @open = true
    @score_dice = 0
  end
  def calculateScore(dice, round)
    @round_score = 0
    occurence = Hash.new(0)
    dice.map {|i| occurence[i] += 1}
    for i in (1..6)
      if occurence[i] >= 3
        @score_dice += 3
        if i == 1
          @round_score += 1000
        else
          @round_score += (i*100)
        end
        occurence[i] -= 3
      end
    end
    @round_score += (occurence[1]*100 + occurence[5]*50)
    @score_dice += occurence[1]
    @score_dice += occurence[5]
    occurence[1]=0
    occurence[5]=0
    @no_dice = 0
    for i in (1..6)
      @no_dice += occurence[i]
      if occurence[i] > 0
        occurence[i] = 0
      end
    end
    if @round_score == 0 && round > 1
      @score = 0
    else
      @score += @round_score
    end
  end
  def dice_reset(no)
    @no_dice = no
  end
  def reset_score
    @score_dice = 0
  end
end

class DiceSet
  attr_reader :values
  def self.roll(n)
    values = []
    n.times do
      values << Random.rand(1..6)
    end
    return values
  end
end

game = Game.new
game.play()
