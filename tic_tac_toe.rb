class Game
    
    @@turn_count = 1
    @@winner = ''

    def initialize
        puts 'Player 1 - please enter your name.'
        @player_one = gets.chomp
        puts 'Player 2 - please enter your name.'
        @player_two = gets.chomp
        @board = Array.new(3) { Array.new(3, '_') }
    end

    def display_board(board)
        puts "\r"
        puts " #{board[0][0]} | #{board[0][1]} | #{board[0][2]} "
        puts " #{board[1][0]} | #{board[1][1]} | #{board[1][2]} "
        puts " #{board[2][0]} | #{board[2][1]} | #{board[2][2]} "
        puts "\r"
    end

    def player_turn(turn)
        if turn.odd?
            player_choice(@player_one, 'X')
        else
            player_choice(@player_two, 'O')
        end
    end

    def player_choice(player, symbol)
        puts "#{player} please enter your coordinates with a space in between."
        input = gets.chomp
        input_array = input.split
        coord_one = input_array[0].to_i
        coord_two = input_array[1].to_i

        # Loop until input is between 0 and 2, and board space is available, making it valid
        until input.match(/\s/) && coord_one.between?(0, 2) && coord_two.between?(0, 2) && @board[coord_one][coord_two] == '_'
            puts "Please enter valid coordinates."
            input = gets.chomp
            input_array = input.split
            coord_one = input_array[0].to_i
            coord_two = input_array[1].to_i
        end

        add_to_board(coord_one, coord_two, symbol)
    end

    def add_to_board(coord_one, coord_two, symbol)
        @board[coord_one][coord_two] = symbol
        @@turn_count += 1
    end

    # Check 3 across wins
    def three_across
        @board.each do |i|
            if i.all? { |j| j == 'X' }
                @@winner = 'X'
                @@turn_count = 10
            elsif i.all? { |j| j == 'O'}
                @@winner = 'O'
                @@turn_count = 10
            else
                nil # or return
            end
        end
    end

    # Check 3 down wins
    def three_down
        flat = @board.flatten
        flat.each_with_index do |v, i|
            if v == 'X' && flat[i + 3] == 'X' && flat[i + 6] == 'X'
                @@winner = 'X'
                @@turn_count = 10
            elsif v == 'O' && flat[i + 3] == 'O' && flat[i + 6] == 'O'
                @@winner = 'O'
                @@turn_count = 10
            else
                nil # or return
            end
        end
    end

    # Check diagonal wins
    def three_diagonal
        center_val = @board[1][1]
        if center_val == 'X' || center_val == 'O'
            if @board[0][0] && @board[2][2] == center_val # in board, top left to bottom right
                @@winner = center_val
                @@turn_count = 10
            elsif @board[2][0] && @board[0][2] == center_val # in board, bottom left to top right
                @@winner = center_val
                @@turn_count = 10
            end
        else
            nil
        end
    end

    def declare_results
        if @@winner == 'X'
            puts "#{@player_one} wins the game!"
        elsif @@winner == 'O'
            puts "#{@player_two} wins the game!"
        else
            puts "It's a tie..."
        end
    end

    def play_game
        puts "\r\n"
        puts 'Here is your empty board.'
        display_board(@board)

        until @@turn_count >= 10 do
            player_turn(@@turn_count)
            three_across
            three_down
            three_diagonal
            display_board(@board)
        end

        declare_results
    end

end