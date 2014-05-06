class AthBot1 < RTanque::Bot::Brain
  NAME = 'Andrew'
  include RTanque::Bot::BrainHelper

  TURRET_FIRE_RANGE = RTanque::Heading::ONE_DEGREE * 1.0
  SWITCH_CORNER_TICK_RANGE = (600..1000)

  def rng
    @rng ||= Random.new
  end

  def tick!
    ## main logic goes here
    if (target = self.nearest_target)
      self.fire_upon(target)
    else
      self.detect_targets
    end

    self.move
    # use self.sensors to detect things
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Sensors
    
    # use self.command to control tank
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Command
    
    # self.arena contains the dimensions of the arena
    # See http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Arena
  end

  def move
    move_randomly
  end

  def move_randomly
    command.heading = self.sensors.position.heading(RTanque::Point.new(random_width, random_height, self.arena))
    command.speed = MAX_BOT_SPEED
  end

  def random_width
    rng.rand(self.arena.width)
  end

  def random_height
    rng.rand(self.arena.height)
  end
  def nearest_target
    self.sensors.radar.min { |a,b| a.distance <=> b.distance }
  end

  def detect_targets
    self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.heading + RTanque::Heading::HALF_ANGLE
  end

  def fire_upon(target)
    self.command.radar_heading = target.heading
    self.command.turret_heading = target.heading
    if self.sensors.turret_heading.delta(target.heading).abs < TURRET_FIRE_RANGE
      self.command.fire(MAX_FIRE_POWER)
    end
  end


end
