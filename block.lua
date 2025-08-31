local sin, cos = math.sin, math.cos
local A, B = 0, 0
local width, height = 120, 40 
local scale = 20
local luminance = ".,-~:;=!*#$@" 

local vertices = {
  {-1, -1, -1}, {1, -1, -1},
  {1,  1, -1}, {-1,  1, -1},
  {-1, -1,  1}, {1, -1,  1},
  {1,  1,  1}, {-1,  1,  1}
}

local edges = {
  {1,2},{2,3},{3,4},{4,1},
  {5,6},{6,7},{7,8},{8,5},
  {1,5},{2,6},{3,7},{4,8}
}

local function clear()
  io.write("\27[2J\27[H")
end

while true do
  local buffer = {}
  for i=1,width*height do buffer[i] = " " end
  local projected = {}

  for i,v in ipairs(vertices) do
    local x,y,z = v[1], v[2], v[3]

    local x1 = x*cos(B) - z*sin(B)
    local z1 = x*sin(B) + z*cos(B)
    local y1 = y*cos(A) - z1*sin(A)
    z1 = y*sin(A) + z1*cos(A)

    z1 = z1 + 5

    local ooz = 1/z1
    local xp = math.floor(width/2 + scale * x1 * ooz * 2)
    local yp = math.floor(height/2 - scale * y1 * ooz)

    projected[i] = {xp, yp}
  end

  for _,e in ipairs(edges) do
    local p1, p2 = projected[e[1]], projected[e[2]]
    local x1,y1 = p1[1], p1[2]
    local x2,y2 = p2[1], p2[2]

    local dx = math.abs(x2-x1)
    local dy = math.abs(y2-y1)
    local sx = x1 < x2 and 1 or -1
    local sy = y1 < y2 and 1 or -1
    local err = dx - dy

    while true do
      if x1 >=0 and x1 < width and y1 >=0 and y1 < height then
        local idx = x1 + y1*width + 1
        local char = luminance:sub(((x1+y1) % #luminance)+1, ((x1+y1) % #luminance)+1)
        buffer[idx] = char
      end
      if x1 == x2 and y1 == y2 then break end
      local e2 = 2*err
      if e2 > -dy then err = err - dy; x1 = x1 + sx end
      if e2 < dx then err = err + dx; y1 = y1 + sy end
    end
  end

  clear()
  for i=1,#buffer do
    io.write(buffer[i])
    if i % width == 0 then io.write("\n") end
  end

  A = A + 0.05
  B = B + 0.03

  local t = os.clock() + 0.03
  while os.clock() < t do end
end
