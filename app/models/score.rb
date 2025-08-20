class Score < ApplicationRecord
  belongs_to :round
  belongs_to :player

  serialize :words, type: Array, coder: YAML  
  serialize :cards, type: Array, coder: YAML  

  before_save :calculate_value

  private

  def calculate_value
    point_value = self.words.sum { |word| word_value(word)}    
    penalty_value = self.cards.sum { |card| letter_value(card)}    
    score = point_value - penalty_value
    self.value = [score, 0].max
  end 

  def word_value word 
    chunks = word.scan(/[A-Z]{2,}|[a-zA-Z]/)
    chunks.sum { |chunk| letter_value(chunk) }
  end

  def letter_value letter
    case letter.upcase
    when 'Q', 'Z'
      10
    when 'J', 'X'
      8
    when 'K'
      6
    when 'F', 'H', 'V', 'W', 'Y'
      5
    when 'B', 'C', 'M', 'P'
      4
    when 'D', 'G', 'L'
      3
    when 'N', 'R', 'S', 'T', 'U'
      2
    when 'A', 'E', 'I', 'O'
      1
    when 'QU'
      9
    when 'ER'
      7
    when 'CL'
      10
    when 'IN'
      7
    when 'TH'
      9
    else 
      0
    end
  end 


end
