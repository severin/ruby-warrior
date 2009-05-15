class Player
  
  def play_turn(warrior)
    unless @not_first_turn
      warrior.pivot!
      @not_first_turn = true
      return
    end
    
    turn_around!(warrior) or exit!(warrior) or heal!(warrior) or go_on!(warrior)
    
    update_health(warrior)
  end
  
  def turn_around!(warrior)
    if(warrior.feel(direction).wall?)
      warrior.pivot!
      return true
    else
      return false
    end
  end
  
  def exit!(warrior)
    if(warrior.feel(direction).stairs?)
      warrior.walk!(direction)
      return true
    elsif(warrior.feel(reverse_direction).stairs?)
      warrior.walk!(reverse_direction)
      return true
    else
      return false
    end
  end
  
  def go_on!(warrior)
    if see(warrior).enemy? && warrior.feel(direction).empty?
      warrior.shoot!
    elsif warrior.feel(direction).empty?
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
    :forward #@direction ||= :backward
  end
  def reverse_direction
    :backward #direction == :forward ? :backward : :forward
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
  
  def see(warrior)
    warrior.look(direction).select {|s| !s.empty?}.first || warrior.look(direction).last
  end
end
