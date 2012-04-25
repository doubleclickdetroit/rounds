module Feed

  def self.recent(time=nil)
    args  = time ? [:before, time] : :recent
    items = [Round,Slide,Comment].inject([]) do |arr,klass|
      arr << klass.send(*args); arr
    end.flatten
    items.sort! { |a,b| a.created_at <=> b.created_at }
    items.slice(0..9)
  end

end
