object @slide

attributes :type, :id, :round_id, :position, :fid, :votes

node(:content) {|slide| slide.content }
node(:comment_count) {|slide| slide.comment_count }
node(:round_lock) {|slide| !!slide.round.round_lock }