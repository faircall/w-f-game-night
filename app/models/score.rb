class Score < ApplicationRecord
  belongs_to :round
  belongs_to :player

  serialize :words, type: Array, coder: YAML  
  serialize :cards, type: Array, coder: YAML  

  before_create :calculate_value

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
    when 'A', 'E', 'I', 'O'
      2
    when 'L', 'S', 'T'
      3
    when 'U', 'Y'
      4
    when 'D', 'M', 'N', 'R'
      5
    when 'F', 'G', 'P'
      6
    when 'H', 'ER', 'IN'
      7
    when 'B', 'C', 'K'
      8
    when 'QU', 'TH'
      9    
    when 'W', 'CL'
      10        
    when 'V'
      11
    when 'X'
      12
    when 'J'
      13
    when 'Z'
      14
    when 'Q'
      15
    else 
      0
    end
  end 


end
