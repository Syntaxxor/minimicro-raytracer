// Raytracer by Syntaxxor.
import "vector"

min = function(a, b)
	if a < b then
		return a
	else
		return b
	end if
end function

max = function(a, b)
	if a > b then
		return a
	else
		return b
	end if
end function

trace_sphere = function(r0, rd, s0, sr)
	a = rd.dot(rd)
	s0_r0 = r0.sub(s0)
	b = 2.0 * rd.dot(s0_r0)
	c = s0_r0.dot(s0_r0) - (sr * sr)
	if b*b - 4.0*a*c < 0.0 then
		return -1.0
	end if
	return (-b - sqrt((b*b) - 4.0*a*c))/(2.0*a)
end function

trace_plane = function(r0, rd, p0, pn)
	denom = -pn.dot(rd)
	if denom < 0.0 then
		return -1.0
	end if
	p0r0 = p0.sub(r0)
	return -p0r0.dot(pn) / denom
end function

compare_dist = function(d0, d1)
	return d1 > 0.0 and (d0 < 0.0 or d1 < d0)
end function

trace_world = function(r0, rd)
	res = {"dist": -1.0}
	
	s0 = vector.newVector(0.0, 0.0, 5.0)
	sr = 1.0
	dist = trace_sphere(r0, rd, s0, sr)
	if compare_dist(res.dist, dist) then
		res.dist = dist
		wp = rd.scale(dist).add(r0)
		norm = wp.sub(s0).normalized
		res.norm = norm
		res.col = color.red
	end if
	
	pn = vector.newVector(0.0, 1.0, 0.0)
	p0 = vector.newVector(0.0, -1.0, 0.0)
	dist = trace_plane(r0, rd, p0, pn)
	if compare_dist(res.dist, dist) then
		res.dist = dist
		res.norm = pn
		res.col = color.green
	end if
	
	return res
end function

trace_shadows = function(r0, rd)
	s0 = vector.newVector(0.0, 0.0, 5.0)
	sr = 1.0
	dist = trace_sphere(r0, rd, s0, sr)
	if dist > 0.0 then
		return true
	end if
	
	pn = vector.newVector(0.0, 1.0, 0.0)
	p0 = vector.newVector(0.0, -1.0, 0.0)
	dist = trace_plane(r0, rd, p0, pn)
	if dist > 0.0 then
		return true
	end if
	
	return false
end function

// Trace the whole screen.
clear
r0 = vector.newVector(0.0, 0.0, 0.0)
sun_dir = vector.newVector(0.5, 1.0, -0.75).normalized
gfx.scale = 2.0
w = gfx.width / gfx.scale
h = gfx.height / gfx.scale
aspect = w / h
start_time = time
for y in range(0, h)
	if key.pressed("escape") then
		break
	end if
	for x in range(0, w)
		u = (x / w) * 2.0 - 1.0
		v = (y / h) * 2.0 - 1.0
		u = u * aspect
		rd = vector.newVector(u, v, 1.0).normalized
		
		res = trace_world(r0, rd)
		if res.dist > 0.0 then
			wp = rd.scale(res.dist).add(r0)
			lightness = max(sun_dir.dot(res.norm), 0.0)
			if lightness > 0.0 then
				if trace_shadows(wp, sun_dir) then
					lightness = 0.0
				end if
			end if
			lightness = max(lightness, 0.1)
			gfx.setPixel(x, y, color.lerp(color.black, res.col, lightness))
		else
			gfx.setPixel(x, y, color.aqua)
		end if
	end for
end for
end_time = time
elapsed = end_time - start_time
print "Render finished in " + str(elapsed) + " seconds."
while not key.pressed("escape")
end while
clear