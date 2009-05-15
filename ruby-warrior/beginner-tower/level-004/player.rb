class Player
  
  def play_turn(warrior)
    
    heal!(warrior) or go_on!(warrior)
    
    update_health(warrior)
  end
  
  def go_on!(warrior)
    warrior.feel.empty? ? warrior.walk! : warrior.attack!
  end
  
  def heal!(warrior)
    return false if warrior.health == max_health(warrior) || taking_damage?(warrior)
    
    if(warrior.feel(:forward).empty?)
      warrior.rest!
      return true
    else
      if(warrior.feel(:backward).empty?)
        warrior.walk!(:backward)
        return true
      else
        warrior.rest!
        return true
      end
    end
  end
  
  def taking_damage?(warrior)
    warrior.health < health_before(warrior)
  end
  
  def health_before(warrior)
    @health ||= warrior.health
  end
  
  def update_health(warrior)
    @health = warrior.health
  end
  
  def max_health(warrior)
    @max_health ||= warrior.health
  end
end
