subscribers = Subscriber.all
subscribers.each do |s|
	user = User.where(id: s.subscribe_id).first
	s.destroy  if user.nil?
end