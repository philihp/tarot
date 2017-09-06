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

end
