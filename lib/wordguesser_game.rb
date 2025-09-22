class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  attr_accessor :word, :guesses, :wrong_guesses
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  # Get a word from remote "random word" service


  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end

  #addresses first removal of pending!! + just sets instance variable
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  #processes guess and modifies instance variables
  def guess(letter)

    #raise error if nil, empty, or doesn't match a letter, lowercase or uppercase!
    raise ArgumentError if letter.nil? || letter.empty? || !letter.match?(/[a-zA-Z]/)
    
    #covert to lowercase to standardize
    letter = letter.downcase

    #return false if already guesses
    return false if guesses.include?(letter) || @wrong_guesses.include?(letter)

    #if the letter is in the correct word, consider it a correct guess
    if word.include?(letter)
      @guesses += letter
    else 
      @wrong_guesses += letter #wrong, add to wrong guesses
    end 

    #return true bc a successful guess!
    return true
  end


  #retuns one of win or lose or play symbols depending on current game state
  def check_win_or_lose
    
    #lose (womp womp) if more than 7 tries/guesses
    return :lose if @wrong_guesses.length >= 7

    #get unique letters in word that weren't guesses
    letters_left = @word.chars.uniq - @guesses.chars
    
    #player wins if no letters left to guess
    return :win if letters_left.empty?

    #keep game going
    return :play
  end

  #substitutes correct guesses made so far into word!
  def word_with_guesses
    #empty string
    result = ''

    #interate through chars in target word
    @word.each_char do |char|
      if @guesses.include?(char)

        #add to result if guesses
        result += char
     
      else
        #add dash if not guesses
        result += '-'
      end
    end

    return result
  end
    

end
