--[[
	Room module by Superhos v1.0
	License is Creative Commons 0.
]]--

require "smath"

--Simple room module with special room drawing function
--Simple constructor for a room
function Room()
	return {
		objects = {},
		objs = 0 -- Amount of objects
	}
end

--A room that can be graphically manipulated
function MRoom(sw, sh, w, h, x, y, rot, sx, sy)
	return {
		objects = {},
		objs = 0,
		canvas = love.graphics.newCanvas(w, h), -- The canvas used for rendering
		sw = sw, -- ?
		sh = sh, -- ?
		w = w, -- Width of canvas
		h = h, -- Height of canvas
		x = x, -- Translation in X
		y = y, -- Translation in Y
		rot = rot, -- Rotation
		sx = sx, -- Scaling in X
		sy = sy -- Scaling in Y
	}
end

--A constructor for an object
--[[Is important that in the object the next lines of
	code are added to the start of the update method:
	sx = x + room.x
	sy = y + room.y

   This catch is easily fixed by making the room execute a custom update function on every object before executing
   the main update function
]]--
function Object(x, y, sx, sy, r)
	return {
		x = x,
		y = y,
		sx = sx, -- Absolute X
		sy = sy, -- Absolute Y
		room = r
	}
end

--Scroll functions
function ScrollLeft(r, a)
	r.x = r.x + a
	r.x = -math.max(-r.x, 0)
end

function ScrollRight(r, a)
	r.x = r.x - a
	r.x = math.clamp(r.x, -r.w + (r.sw), -a)
end

function ScrollUp(r, a)
	r.y = r.y + a
	r.y = -math.max(-r.y, 0)
end

function ScrollDown(r, a)
	r.y = r.y - a
	r.y = math.clamp(r.y, -r.h + (r.sh), -a)
end

--Add an object to a room
function AddObjToRoom(room, obj)
	room.objects[room.objs] = obj
	room.objs = room.objs + 1
end

AOTR = AddObjToRoom -- Short hand for the function

--Update all the objects of the room
function UpdateRoom(room)
	for i = 0, #room.objects do
		room.objects[i]:update()
	end
end

--Draw all the objects of a normal room
function DrawRoom(room)
	for i = 0, #room.objects do
		room.objects[i]:draw()
	end
end

--Draw all the objects of the room with a global translation, rotation and scaling.
function DrawManipulatedRoom(r)

	--Using a canvas to buffer an image
	love.graphics.setCanvas(r.canvas)

	--Prepare the buffered canvas for transformation
	love.graphics.push()
	love.graphics.translate(r.x, r.y)
	love.graphics.rotate(r.rot)
	love.graphics.scale(r.sx, r.sy)

	--Draw all the objects with a configured canvas
	for i = 0, #r.objects do
		r.objects[i]:draw()
	end
	love.graphics.pop()

	--Reset the canvas to draw on
	love.graphics.setCanvas()

	--Draw our canvas
	love.graphics.draw(r.canvas, 0, 0)
end
