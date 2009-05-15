class Player
  
  def play_turn(warrior)
puts 'selle has ' + warrior.health.to_s + ' hp'    
    turn(reverse_direction) if warrior.feel(direction).wall?
    
    heal!(warrior) or go_on!(warrior)
    
    update_health(warrior)
  end
  
  def go_on!(warrior)
    if warrior.feel(direction).empty?
      warrior.walk!(direction)
    elsif warrior.feel(direction).captive?
      warrior.rescue!(direction)
    elsif warrior.feel(direction).enemy?
      warrior.attack!(direction)
    end
  end
  
  def heal!(warrior)
    # if warrior.health > max_health(warrior)/2
    #   return false
    # end
    
    if(!taking_damage?(warrior))
      if(warrior.health < max_health(warrior))
        warrior.rest!
        return true
      else
        return false
      end
    end
    
    if(warrior.health > max_health(warrior)/2)
      return false
    end
    
    if(warrior.feel(reverse_direction).empty?)
      warrior.walk!(reverse_direction)
      return true
      
    elsif(warrior.feel(direction).empty?)
      if(warrior.health < max_health(warrior))
        warrior.rest!
        return true
      else
        return false
      end
      
    elsif(warrior.feel(reverse_direction).empty?)
      warrior.walk!(reverse_direction)
      return true
      
    end
    return false
  end
  
  def taking_damage?(warrior)
    warrior.health < health_before(warrior)
  end
  
  def healing?
    @healing ||= false
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
  
  def direction
    @direction ||= :backward
  end
  def reverse_direction
    direction == :forward ? :backward : :forward
  end
  def turn(dir)
    @direction = dir
  end
  def turn_forward
    turn :forward
  end
  def turn_backward
    turn :backward
  end
end
