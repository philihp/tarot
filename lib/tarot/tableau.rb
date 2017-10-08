class Tarot::Tableau

  attr_accessor :land

  def initialize
    @land = Array.new(Tarot::MAX_SIZE * 2 - 1){Array.new(Tarot::MAX_SIZE * 2 - 1)}
    @land[Tarot::MAX_SIZE - 1][Tarot::MAX_SIZE - 1] = { terrain: Tarot::CASTLE_TYPE, crowns: 0 }
  end

  def initialize_copy(source)
    @land = source.land.map(&:dup)
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
        yield x, y, self[x, y]
      end
    end
  end

  def legal_size?
    (x_min, x_max, y_min, y_max) = tableau_bounds
    x_max - x_min < Tarot::MAX_SIZE && y_max - y_min < Tarot::MAX_SIZE
  end

  def tableau_bounds
    x_min = y_min = x_max = y_max = Tarot::MAX_SIZE - 1
    realm_iterator do |x, y, tile|
      unless tile.nil?
        (x_min, x_max) = [x_min, x, x_max].minmax
        (y_min, y_max) = [y_min, y, y_max].minmax
      end
    end
    return [x_min, x_max, y_min, y_max]
  end

  def placement_iterator(dir:)
    (x_min, x_max, y_min, y_max) = tableau_bounds

    x_size = x_max - x_min + 1
    y_size = y_max - y_min + 1

    # one cell fewer than the limit on that edge
    x_min_range = [x_max - Tarot::MAX_SIZE + 1, x_min - 1].max
    x_max_range = [x_min + Tarot::MAX_SIZE - 1, x_max + 1].min
    y_min_range = [y_max - Tarot::MAX_SIZE + 1, y_min - 1].max
    y_max_range = [y_min + Tarot::MAX_SIZE - 1, y_max + 1].min

    # constrict the bounds, for example if we're going east, then we can trim one side off of
    # the east edge of the map.
    # Also, if the kingom is skinny (1, 2, or 3 width), then search 2 off the edge in that dir,
    # rather than just the bordering tile of the map edge.
    case dir
    when :n
      if y_size <= Tarot::MAX_SIZE - 2
        y_max_range -= 1
      else
        y_min_range += 1
      end
    when :s
      if y_size <= Tarot::MAX_SIZE - 2
        y_min_range += 1
      else
        y_max_range -= 1
      end
    when :w
      if x_size <= Tarot::MAX_SIZE - 2
        x_max_range -= 1
      else
        x_min_range += 1
      end
    when :e
      if x_size <= Tarot::MAX_SIZE - 2
        x_min_range += 1
      else
        x_max_range -= 1
      end
    end

    # binding.pry unless (0..8).cover?(y_min_range) && (0..8).cover?(y_max_range) &&
    #   (0..8).cover?(x_min_range) && (0..8).cover?(x_max_range)

    print "#{dir} y:(#{y_min_range}..#{y_max_range}) x:(#{x_min_range}..#{x_max_range})\n"

    (y_min_range..y_max_range).map do |y|
      (x_min_range..x_max_range).map do |x|
        yield x, y
      end
    end
  end

  def adjacent_tiles(x, y)
    Tarot::CARDINAL_MODIFIER.map do |direction, offset|
      (dx, dy) = offset
      self[x + dx, y + dy]
    end.compact
  end

  def adjacent_tiles_match(x, y, tile)
    adjacent_tiles(x, y).any? do |t|
      [tile[:terrain], Tarot::CASTLE_TYPE].include? t[:terrain]
    end
  end

  def get_possible_places(current_tile)
    palindrome_tile = (current_tile[:l] == current_tile[:r])
    moves = []
    Tarot::CARDINAL_MODIFIER.map do |direction, offset| # iterate orientation of the tile
      # only check half this list if the tile is the same flipped
      next if palindrome_tile && [:w, :n].include?(direction)
      x_offset, y_offset = offset
      placement_iterator(dir: direction) do |x, y|
        # Tableau has nothing in this spot or in the other spot it would occupy
        next unless self[x,y].nil? && self[x + x_offset, y + y_offset].nil?
        # This spot, or the one to the right matches some adjacent terrain
        next unless adjacent_tiles_match(x, y, current_tile[:l]) ||
          adjacent_tiles_match(x + x_offset, y + y_offset, current_tile[:r])
        moves << yield(x, y, direction)
      end
    end
    moves
  end

  def to_s
    grid = [['.'] + (0..8).to_a.map(&:to_s)] +
      land.map.with_index { |r, i| [i.to_s] + r.map { |c| c.nil? ? ' ' : c[:terrain].to_s } }
    grid.map { |r| r.join(' ') }.join("\n")
  end

  # This makes it easy to grab cells from the array without worrying about something
  # like @land[-1][4] or @land[4,-1] or @land[0][9] going out of bounds. If we go out of
  # bounds, just give back a cell that looks like an empty cell.
  def [](x, y)
    return nil unless x.between?(0, Tarot::MAX_SIZE * 2 - 2)
    return nil unless y.between?(0, Tarot::MAX_SIZE * 2 - 2)
    @land[y][x]
  end

end
