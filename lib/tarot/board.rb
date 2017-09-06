class Tarot::Board

  attr_accessor :rand
  attr_accessor :old_claims, :new_claims

  def initialize(rand:, players:)
    @old_claims = clear_claim_array(players: players)
    @new_claims = clear_claim_array(players: players)
    imagine_future!(with: rand)
  end

  def initialize_copy(source)
    @old_claims = source.old_claims.dup
    @new_claims = source.new_claims.dup
    @rand = source.rand.dup
  end

  def imagine_future!(with: Random.new)
    @rand = with
  end

  def find_next_player
    @old_claims.find { |n| !n.nil? }
  end

  def find_next_player_index
    @old_claims.find_index { |n| !n.nil? }
  end

private

  def clear_claim_array(players:)
    Array.new(players == 2 ? 4 : players) { nil }
  end

end
