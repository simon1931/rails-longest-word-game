require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]
  def new
    vowels = VOWELS.sample(5)
    consonants = (('A'..'Z').to_a - vowels).sample(5)
    @letters = (vowels + consonants).shuffle
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def letter_in_grid?
    attempt = @answer
    grid = @grid.split(' ')
    letters = attempt.upcase.chars
    letters.each do |letter|
      index = grid.index(letter)
      return false if index.nil?

      grid.delete_at(index)
    end
    return true
  end

  def score
    @answer = params[:word]
    @grid = params[:grid]
    @result = if !letter_in_grid?
                "Sorry, but #{@answer.upcase} cannot be built from #{@grid}."
              elsif !english_word?
                "Sorry, but #{@answer.upcase} is not an English word."
              elsif letter_in_grid? && !english_word?
                "Sorry, but #{@answer.upcase} is not an English word."
              elsif letter_in_grid? && english_word?
                "Congratulations! Your word is #{@answer.upcase}, it is in the grid: #{@grid} and is worth #{@answer.upcase.length} points!"
              else
                "toto"
              end
  end
end
