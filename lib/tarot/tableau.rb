class Tarot::Tableau

  attr_accessor :land

  def initialize
    @land = Array.new(Tarot::MAX_SIZE * 2 - 1){Array.new(Tarot::MAX_SIZE * 2 - 1)}
    @land[Tarot::MAX_SIZE][Tarot::MAX_SIZE] = { terrain: Tarot::CASTLE_TYPE, crowns: 0 }
  end

  def initialize_copy(source)
    @land = source.land.dup
  end

  def to_json
    {
      land: @land,
      score: score,
    }
  end

  def score
    #cells = land.inject([]) { |accum, tile| accum << tile[:l] << tile[:r] }
    #properties = cells.inject({}) do |accum, cell|
    properties = land.flatten.inject({}) do |accum, cell|
      next accum if cell.nil?
      if accum[cell[:terrain]].nil?
        accum[cell[:terrain]] = { size: 1, crowns: cell[:crowns] }
      else
        accum_for_terrain = accum[cell[:terrain]]
        accum_for_terrain[:crowns] += cell[:crowns]
        accum_for_terrain[:size] += 1
      end
      accum
    end
    property_scores = properties.map { |k,v| v[:size] * v[:crowns] }
    property_score = property_scores.reduce(:+).to_i

    largest_property = properties.map { |k,v| v[:size] }.max
    total_crowns = properties.map { |k,v| v[:crowns] }.reduce(:+)

    # This could be done lazily, we might not need the last two, but performance gains prob minimal
    [ property_score, largest_property, total_crowns ]
  end

  def realm_iterator
    (0..Tarot::MAX_SIZE * 2 - 2).map do |x|
      (0..Tarot::MAX_SIZE * 2 - 2).map do |y|
        yield x, y, @land[y][x]
      end
    end
  end

  def adjacent_iterator(x, y, check, &block)
    Tarot::CARDINAL_MODIFIER.map do |orientation, offset|
      (y_offset, x_offset) = offset
      x_new = x_offset + x
      y_new = y_offset + y
      next if x_new < 0 || x_new >= Tarot::MAX_SIZE * 2 - 1
      next if y_new < 0 || y_new >= Tarot::MAX_SIZE * 2 - 1
      tile = @land[y_new][x_new]
      next unless check.call(x_new, y_new, tile)
      yield x_new, y_new, tile, orientation
    end
  end

  def empty_adjacent(x, y, &block)
    adjacent_iterator(x, y, ->(_, _, ntile){ ntile.nil? }) do |mx, my, mtile, morientation|
      yield mx, my, mtile, morientation
    end
  end

  def flipped_tile(tile)
    {
      id: tile[:id],
      l: tile[:r],
      r: tile[:l],
      flipped: true,
    }
  end

  def get_possible_places(current_tile)
    moves = []
    x_min = Float::INFINITY
    x_max = 0
    y_min = Float::INFINITY
    y_max = 0
    realm_iterator do |x, y, tile|
      unless tile.nil?
        (x_min, x_max) = [x_min, x].minmax
        (y_min, y_max) = [y_min, y].minmax
      end
    end

    # pseudocode:

    # for the current tile, or the flipped current tile
    #   give me all of the tiles on my board that terrain or castle
    #     give me all the orientations that the tile can go
    #       for each of these, does it keep the bound within 5x5?

    [current_tile, flipped_tile(current_tile)].each do |proposed_tile|
      current_piece = proposed_tile[:l]
      second_piece = proposed_tile[:r]
      current_type = current_piece[:terrain]
      realm_iterator do |x, y, tile|
        # make sure this piece is either the castle or of the same type
        if !tile.nil? && [current_type, Tarot::CASTLE_TYPE].include?(tile[:terrain])
          # find all empty spots next to this piece
          empty_adjacent(x, y) do |nx, ny, _|
            # ensure there are other spots for the next piece in the tile
            #to_enum(:empty_adjacent, nx, ny)
            empty_adjacent(nx, ny) do |mx, my, _, orientation|
              if proposed_tile.key?(:flipped)
                moves << [mx, my, Tarot::CARDINAL_INVERSE[orientation]]
              else
                moves << [nx, ny, orientation]
              end
            end
          end
        end
      end
    end

    # TODO: once this works, and we have test cases... make it functional. appending to an array
    #       isn't really that nice and functional.
    moves
  end

end
