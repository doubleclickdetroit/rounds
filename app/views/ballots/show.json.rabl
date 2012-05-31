object @ballot

attributes :id, :slide_id, :vote 

node(:created_at) {|record| record.created_at.to_s}
