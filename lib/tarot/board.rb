class Tarot::Board

  attr_accessor :rand
  attr_accessor :old_claims, :new_claims

  def initialize(rand:, players:)
    if players == 3
      @old_claims = [ nil, nil, nil ]
      @new_claims = [ nil, nil, nil ]
    else
      @old_claims = [ nil, nil, nil, nil ]
      @new_claims = [ nil, nil, nil, nil ]
    end
    imagine_future!(with: rand)
  end

  def imagine_future!(with: Random.new)
    @rand = with
  end

  def prepare_for_new_round!
    if @new_claims.compact.size == @new_claims.size
      @old_claims = @new_claims
      @new_claims = [ nil, nil, nil, nil ]
    end
    # TODO: draw new tiles
  end

end
