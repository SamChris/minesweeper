# class Tile
#   attr_reader :loc,
#   ADJ_TILES = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
# end

class Board
  attr_accessor :bomb_locales, :flag_locales, :fringe_board, :safe_squares
  ADJ_SQUARES = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
  NUM_MINES = 40
  SIZE = 16

  def initialize
    create_boards
    @safe_squares = []
    @fringe_board = create_fringe_board
    display_fringe_board(@fringe_board)
  end

  def display_fringe_board(fringe_board)
    fringe_board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        print "#{fringe_board[i][j]} "
      end
      print "\n"
    end
  end

  def create_boards
    @bomb_locales = create_mines(SIZE, SIZE)
    @fringe_board = Array.new(SIZE) {Array.new(["*"] * SIZE)}

  end

  def create_fringe_board
    #fringe_squares exclude those squares with bombs and those that have
    #no surrounding bombs
        @fringe_board.each_with_index do |row, x|
      row.each_with_index do |el, y|
        location = [x, y]
        if @bomb_locales.include?(location)
          fringe_board[x][y] = "B"
        else
          bombs = sweep_for_mines(location)
          fringe_board[x][y] = bombs if bombs > 0
        end
      end
    end

    @fringe_board
  end

  def create_mines(row_size, col_size)
    mine_array = []
    while mine_array.length < NUM_MINES
      x, y = rand(row_size), rand(col_size)
      mine_array << [x, y] unless mine_array.include?([x, y])
    end
    mine_array
  end

  def sweep_for_mines(location)
    valid_locations = get_valid_locations(location)
    bombs = 0
    valid_locations.each do |location|
      bombs += 1 if @bomb_locales.include?(location)
    end
    bombs
  end

  def get_valid_locations(loc)
    location = loc.dup
    locals = []
    ADJ_SQUARES.each do |adjacent|
      location[0], location[1] = location[0]+adjacent[0], location[1]+adjacent[1]
      locals << location if (location[0].between?(0, SIZE-1)) && (location[1].between?(0, SIZE-1))
      location = loc.dup
    end

    locals
  end

  def display_board
    @player_board.each do |row|
     puts "#{row}"
    end
  end

  def has_bomb?(pos)
    x, y = pos
    @fringe_board[x][y] == 'B'
  end

  def reveal_safe_squares(location)
    return if @safe_squares.include?(location)

    valid_arr = get_valid_locations(location)

    if valid_arr.any? { |pos| has_bomb?(pos) }
      @safe_squares << location
      return
    else
      @safe_squares << location
      valid_arr.each do |pos|
      reveal_safe_squares(pos)
      end
    end
  end




    # revealed_squares = [location]
    # i = -1
    # while i < (revealed_squares.length - 1)
    #   i += 1
    #
    #   pos = revealed_squares[i]
    #   p pos
    #   unless ( fringe_board[pos[0]][pos[1]].is_a?(Fixnum) )
    #     safe_locations = spread_out_squares(revealed_squares, location)
    #     revealed_squares += safe_locations if safe_locations
    #   end
    # end
    #
    # revealed_squares


  def spread_out_squares(revealed_squares, loc)

    safe_locations = []
    valid_locals = get_valid_locations(loc)
    valid_locals.each do |location|
      safe_locations << location unless ( @bomb_locales.include?(location) || revealed_squares.include?(location) )
    end
    safe_locations
  end

  def bombed?(pos)
    return true if @bomb_locales.include?(pos)
    false
  end

  def play
     update_board(@safe_squares)
    while @safe_squares.length < ( (SIZE*SIZE) - NUM_MINES )

        print  "\n"
        puts "Please input your choice"
        user_response = gets.chomp.split(' ').map {|num| num.to_i}
        break if bombed?(user_response)

        reveal_safe_squares(user_response)
        update_board(@safe_squares)
    end

    if bombed?(user_response)
      puts "You're blasted!!!"
    else
      puts "You won!!! Congratulations"
    end
  end

  def update_board(safe_squares)
    @fringe_board.each_with_index do |row, i|
      row.each_with_index do |el, j|
        if ( !@safe_squares.include?([i, j]) )
          print "* "
        elsif @safe_squares.include?([i, j])
          print "D "
        else
          print @fringe_board[i][j]
        end
      end
      print "\n"
    end
    print "\n\n\n\n"
    display_fringe_board(@fringe_board)
  end

end


a = Board.new







