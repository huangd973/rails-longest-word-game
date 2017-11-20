require 'open-uri'

class WordGameController < ApplicationController
  def game
      @grid = (0..9).map { (65 + rand(26)).chr }
      @start_time = Time.now.to_i
  end

  def score
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    @grid = params[:grid]
    @attempt = params[:attempt]
    @result = { time: (@end_time - @start_time), message: message(@attempt, @grid) }
    if english_word?(@attempt) && letter?(@attempt, @grid)
      @result[:score] = @attempt.size
    else
      @result[:score] = 0
    end
    @result
  end

  def letter?(attempt, grid)
    array_l = attempt.upcase.chars
    array_l.each do |leter|
      return false if array_l.count(leter) > grid.count(leter)
  end
  true
  end

  def english_word?(attempt)
    dictionnary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/" + attempt).read)
    dictionnary["found"] ? true : false
  end

  def message(attempt, grid)
    return "Looser!" if attempt == ""
    return "not in the grid" if letter?(attempt, grid) == false
    return "not an english word" if english_word?(attempt) == false
    "Well Done!"
  end
end
