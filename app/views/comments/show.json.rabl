object @comment

attributes :id, :slide_id, :text, :inappropriate

node(:created_at) {|record| record.created_at.to_s}
