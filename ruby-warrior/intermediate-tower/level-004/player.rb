class Player
  
  def play_turn(warrior)
    
    puts "health: #{warrior.health}"
    puts "around: #{sense(warrior).map{|k,v| "#{k}: #{v}"}.join(', ')}"
    puts "direction of stairs: #{warrior.direction_of_stairs}"
    
    if !enemy_position(warrior) && warrior.health < 14
      warrior.rest!
    elsif enemy = enemy_position(warrior)
      puts 'attacking an enemy...'
      if (retreat = retreat_position(warrior)) && warrior.health < 14
        warrior.walk! retreat
      else
        warrior.attack! enemy
      end
    elsif captive = distant_captive_position(warrior)
      puts 'hearing a captive...'
      warrior.walk! captive
    elsif captive = captive_position(warrior)
      puts 'releasing a captive...'
      warrior.rescue! captive
    elsif warrior.health < 14
      puts 'resting...'
      warrior.rest!
    
    else
      puts 'walking to stairs...'
      warrior.walk! warrior.direction_of_stairs
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
  def distant_captive_position(warrior)
    if (sp = warrior.listen.select {|sp| sp.captive?}.first) && !captive_position(warrior)
      warrior.direction_of(sp)
    end
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
