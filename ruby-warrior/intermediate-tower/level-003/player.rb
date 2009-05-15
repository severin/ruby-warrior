class Player
  
  def play_turn(warrior)
    puts "I'm feeling " + sense(warrior).map {|k, v| "#{k}: #{v}"}.flatten.join(', ') + " (health is #{warrior.health})"
    
    if captive = captive_position(warrior)
      warrior.rescue! captive
    elsif enemy = enemy_position(warrior)
      if (retreat = retreat_position(warrior)) && warrior.health < 14
        warrior.walk! retreat
      else
        warrior.attack! enemy
      end
      
    elsif warrior.health < 20
      warrior.rest!
    
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
  end
  
  def enemy_position(warrior)
    sense(warrior).values.include?(:enemy) ? sense(warrior).select {|k,v| v == :enemy}.first.first : nil
  end
  
  def retreat_position(warrior)
    sense(warrior).values.include?(:empty) ? sense(warrior).select {|k,v| v == :empty}.first.first : nil
  end

  def captive_position(warrior)
    sense(warrior).values.include?(:captive) ? sense(warrior).select {|k,v| v == :captive}.first.first : nil
  end
  
  def sense(warrior)
    result = Hash.new
    [:forward, :backward, :left, :right].each do |dir|
      feeling = warrior.feel(dir)
      result[dir] = 
        if feeling.empty?;      :empty
        elsif feeling.wall?;    :wall
        elsif feeling.enemy?;   :enemy
        elsif feeling.captive?; :captive
        else                    :strange_stuff
      end
    end
    
    result
  end
end
