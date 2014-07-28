require "set"

class WordJumble
	def initialize(dictionary_file)
		create_dictionary(dictionary_file)
	end

	# Create the hash of set of letters to words with that set of letters
	def create_dictionary(dictionary_file)

		# Initialize the dictionary, making all default values [] (instead of nil)
		@dictionary = Hash.new { |h,k| h[k] = [] } 

		File.foreach(dictionary_file) do |word|

			# Remove the trailing newline
			word = word.gsub("\n","")

			# Sort the letters in the word, so we can index all words with the exact same letters in the hash
			key = word.split("").sort
			@dictionary[key] << word
		end
	end

	def find_words(word)
		t = Time.now
		words = []

		# Create a list of all of the possible combination sets
		letter_sets = Set.new().add([])	

		# Sort the word first, so we know the created sets will be in order, and we won't need to
		# sort each time
		sorted_word = word.split("").sort

		# Only accept words in our dictionary
		raise "word not found" unless @dictionary[sorted_word].include?(word)

		sorted_word.each do |letter|

			# Append the new letter to each of the elements already in the list, and check for
			# existence in the dictionary
			new_set = []
			letter_sets.each do |set|
				letter_combo = set.dup
				letter_combo.push(letter)

				# If there is no entry for this word, it will append an empty list, having no 
				# impact on the final result
				words.concat(@dictionary[letter_combo])
				new_set << letter_combo
			end
			letter_sets = letter_sets.union(new_set)
		end

		# Return only uniques--this might speed up the delete operation below
		words = words.uniq

		# Remove input word from the list of matches
		words.delete(word)
		puts Time.now-t
		words
	end
end

#################################### TEST ROUTINE ###########################################


word_jumble = WordJumble.new(ARGV[0])

puts "Welcome to the word jumbler!"

# Read in input in a loop until the program receives exit input
word = ""
while word != "XX"
	puts "Please enter a word, or enter \"XX\" to exit."
	word = STDIN.gets.chomp

	begin
		puts "#####################################################################"

		words = word_jumble.find_words(word)
		if words.empty?
			puts "No matches found."
		else
			puts words
		end
	rescue 
		puts "Word not found."
	end
end

puts "Goodbye!"