class Player
  
  def play_turn(warrior)
    puts "I'm feeling " + sense(warrior).map {|k, v| "#{k}: #{v}"}.flatten.join(', ') + "(health is #{warrior.health})"
    
    if enemy = enemy_position(warrior)
      puts "there's an enemy"
      if (retreat = retreat_position(warrior)) && warrior.health < 14
        puts "and I can retreat"
        warrior.walk! retreat
      else
        puts "and i have to attack"
        warrior.attack! enemy
      end
      
    elsif warrior.health < 20
      puts "I'm feeling not perfect and I'm resting"
      warrior.rest!
    
    else
      puts "Let's go on"
      warrior.walk!(warrior.direction_of_stairs)
    end
  end
  
  def enemy_position(warrior)
    sense(warrior).values.include?(:enemy) ? sense(warrior).select {|k,v| v == :enemy}.first.first : nil
  end
  
  def retreat_position(warrior)
    sense(warrior).values.include?(:empty) ? sense(warrior).select {|k,v| v == :empty}.first.first : nil
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
