class Dib < Watching
protected
  def message
    "Round #{round_id} is unlocked! Your turn!"
  end

  def channel
    "/api/rounds/#{round_id}/dib"
  end
end
