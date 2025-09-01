-- block.lua but with faces

local sin, cos = math.sin, math.cos
local A, B = 0, 0
local width, height = 120, 40
local scale = 20
local luminance = ".,-~:;=!*#$@"

local step = 0.3

local function clear()
  io.write("\27[2J\27[H")
end

while true do
  local buffer, zbuffer = {}, {}
  for i=1,width*height do
    buffer[i] = " "
    zbuffer[i] = -1e9
  end

  for x=-1,1,step do
    for y=-1,1,step do
      for z=-1,1,2 do  
        local vx, vy, vz = x, y, z

        local x1 = vx*cos(B) - vz*sin(B)
        local z1 = vx*sin(B) + vz*cos(B)
        local y1 = vy*cos(A) - z1*sin(A)
        z1 = vy*sin(A) + z1*cos(A)

        z1 = z1 + 4

        local ooz = 1/z1
        local xp = math.floor(width/2 + scale * x1 * ooz * 2)
        local yp = math.floor(height/2 - scale * y1 * ooz)

        local L = (vz+1)/2
        local char = luminance:sub(math.floor(L * (#luminance-1))+1,
                                   math.floor(L * (#luminance-1))+1)

        local idx = xp + yp*width + 1
        if idx>=1 and idx<=#buffer and ooz > zbuffer[idx] then
          buffer[idx] = char
          zbuffer[idx] = ooz
        end
      end
    end
  end

  for y=-1,1,step do
    for z=-1,1,step do
      for x=-1,1,2 do
        local vx, vy, vz = x, y, z

        local x1 = vx*cos(B) - vz*sin(B)
        local z1 = vx*sin(B) + vz*cos(B)
        local y1 = vy*cos(A) - z1*sin(A)
        z1 = vy*sin(A) + z1*cos(A)

        z1 = z1 + 4
        local ooz = 1/z1
        local xp = math.floor(width/2 + scale * x1 * ooz * 2)
        local yp = math.floor(height/2 - scale * y1 * ooz)

        local L = (vx+1)/2
        local char = luminance:sub(math.floor(L * (#luminance-1))+1,
                                   math.floor(L * (#luminance-1))+1)

        local idx = xp + yp*width + 1
        if idx>=1 and idx<=#buffer and ooz > zbuffer[idx] then
          buffer[idx] = char
          zbuffer[idx] = ooz
        end
      end
    end
  end

  for x=-1,1,step do
    for z=-1,1,step do
      for y=-1,1,2 do
        local vx, vy, vz = x, y, z

        local x1 = vx*cos(B) - vz*sin(B)
        local z1 = vx*sin(B) + vz*cos(B)
        local y1 = vy*cos(A) - z1*sin(A)
        z1 = vy*sin(A) + z1*cos(A)

        z1 = z1 + 4
        local ooz = 1/z1
        local xp = math.floor(width/2 + scale * x1 * ooz * 2)
        local yp = math.floor(height/2 - scale * y1 * ooz)

        local L = (vy+1)/2
        local char = luminance:sub(math.floor(L * (#luminance-1))+1,
                                   math.floor(L * (#luminance-1))+1)

        local idx = xp + yp*width + 1
        if idx>=1 and idx<=#buffer and ooz > zbuffer[idx] then
          buffer[idx] = char
          zbuffer[idx] = ooz
        end
      end
    end
  end

  clear()
  for i=1,#buffer do
    io.write(buffer[i])
    if i % width == 0 then io.write("\n") end
  end

  A = A + 0.04
  B = B + 0.03

  local t = os.clock() + 0.03
  while os.clock() < t do end
end
