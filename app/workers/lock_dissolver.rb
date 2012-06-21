class LockDissolver
  @queue = :lock_timeout_queue

  def self.perform(round_lock_id)
    lock = RoundLock.find round_lock_id
    lock.try(:destroy)
  end
end
