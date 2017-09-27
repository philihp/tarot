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

  def placement_iterator(x_bound:, y_bound:)
    x_min = y_min = x_max = y_max = Tarot::MAX_SIZE - 1
    realm_iterator do |x, y, tile|
      unless tile.nil?
        (x_min, x_max) = [x_min, x, x_max].minmax
        (y_min, y_max) = [y_min, y, y_max].minmax
      end
    end
    ((y_max - (Tarot::MAX_SIZE - 1))..(y_min + (Tarot::MAX_SIZE - 1) + y_bound)).map do |y|
      ((x_max - (Tarot::MAX_SIZE - 1))..(x_min + (Tarot::MAX_SIZE - 1) + x_bound)).map do |x|
        yield x, y
      end
    end
  end

  def adjacent_tiles(x, y)
    Tarot::CARDINAL_MODIFIER.map do |offset|
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

    moves = []

    # horizontals
    placement_iterator(x_bound: -1, y_bound: 0) do |x, y|
      # Has previous tile at this spot, and to the right
      next unless self[x,y].nil? && self[x + 1, y].nil?
      # This spot, or the one to the right matches some adjacent terrain
      next unless adjacent_tiles_match(x, y, current_tile[:l]) ||
        adjacent_tiles_match(x + 1, y, current_tile[:r])
      moves << yield(x, y, :h)
    end +
    # verticals
    placement_iterator(x_bound: 0, y_bound: -1) do |x, y|
      # No previous tile at this spot, or below
      next unless self[x,y].nil? && self[x, y + 1].nil?
      # This spot, or the one below matches some adjacent terrain
      next unless adjacent_tiles_match(x, y, current_tile[:l]) ||
        adjacent_tiles_match(x, y + 1, current_tile[:r])
      moves << yield(x, y, :v)
    end

    moves
  end

  def to_s
    grid = [['.'] + (0..9).to_a.map(&:to_s)] +
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
