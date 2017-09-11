class Tarot::Tableau

  attr_accessor :rand
  attr_accessor :land

  def initialize(rand:)
    imagine_future!(with: rand)
    @land = []
  end

  def imagine_future!(with: Random.new)
    @rand = with
  end

  def to_json
    {
      land: @land
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
    property_scores.reduce(:+).to_i
  end

end
