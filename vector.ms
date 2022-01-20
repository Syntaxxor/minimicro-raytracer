// Vector class, including initializer.
Vector = {"x": 0.0, "y": 0.0, "z": 0.0}
newVector = function(x, y, z)
	res = new Vector
	res.x = x
	res.y = y
	res.z = z
	return res
end function

Vector.add = function(other)
	return newVector(self.x + other.x, self.y + other.y, self.z + other.z)
end function
Vector.sub = function(other)
	return newVector(self.x - other.x, self.y - other.y, self.z - other.z)
end function
Vector.scale = function(s)
	return newVector(self.x * s, self.y * s, self.z * s)
end function
Vector.dot = function(other)
	return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
end function
Vector.length = function()
	return sqrt(self.dot(self))
end function
Vector.normalized = function()
	return self.scale(self.length())
end function