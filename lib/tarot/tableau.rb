class Tarot::Tableau

  attr_accessor :land

  def initialize
    @land = []
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
    cells = land.inject([]) { |accum, tile| accum << tile[:l] << tile[:r] }
    properties = cells.inject({}) do |accum, cell|
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

end
