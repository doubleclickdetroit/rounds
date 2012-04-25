module Feed

  def self.recent(time=nil)
    items = []
    args  = time ? [:before, time] : :recent
    [Round,Slide,Comment].each do |klass|
      items << klass.send(*args) 
    end
    items.flatten!
    items.sort! { |a,b| a.created_at <=> b.created_at }
    items.slice(0..9)
  end

end
