func updatePosition(currentPosition, timePassed):
	var step = 1 * (timePassed/5);
	var theta = atan(abs(currentPosition.x)/abs(currentPosition.y));
	var newPosition = currentPosition;
	if(currentPosition.x < 0):
		newPosition.x += step * sin(theta)
		if newPosition.x > 0:
			newPosition.x = 0;
	elif(currentPosition.x > 0):
		newPosition.x -= step * sin(theta)
		if newPosition.x < 0:
			newPosition.x = 0;
	if(currentPosition.y < 0):
		newPosition.y += step * cos(theta)
		if newPosition.y > 0:
			newPosition.y = 0;
	elif(currentPosition.y > 0):
		newPosition.y -= step * cos(theta)
		if newPosition.y < 0:
			newPosition.y = 0;
	return newPosition;
