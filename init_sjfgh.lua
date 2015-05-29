local c_mese = minetest.get_content_id("default:mese")
local c_sand = minetest.get_content_id("default:sand")
local c_torch = minetest.get_content_id("default:torch")
local c_water = minetest.get_content_id("default:water_source")

local function sandport(pos)
	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = 4
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y-3, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+1, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
	local nodes = manip:get_data()
	print("pre")

	for i = -1,1,2 do
		for j = -1,1,2 do
			if nodes[area:index(pos.x+i, pos.y+2, pos.z+j)] ~= c_torch
			or minetest.get_node({x=pos.x+i, y=pos.y+2, z=pos.z+j}).param2 ~= 1
			or nodes[area:index(pos.x+i, pos.y+1, pos.z+j)] ~= c_sand
			or nodes[area:index(pos.x+i, pos.y, pos.z+j)] ~= c_sand then
				return false
			end
		end
		if nodes[area:index(pos.x+i, pos.y-2, pos.z+i*2)] ~= c_mese
		or nodes[area:index(pos.x+i*2, pos.y-2, pos.z+i)] ~= c_mese
		or (not minetest.registered_nodes[minetest.get_node({x=pos.x+i*2, y=pos.y-1, z=pos.z}).name].walkable)
		or (not minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z+i*2}).name].walkable)
		or nodes[area:index(pos.x+i, pos.y, pos.z)] ~= c_sand
		or nodes[area:index(pos.x, pos.y, pos.z+i)] ~= c_sand
		or nodes[area:index(pos.x+i*2, pos.y, pos.z)] ~= c_water
		or nodes[area:index(pos.x, pos.y, pos.z+i*2)] ~= c_water then
			return false
		end
	end
	for k = 3,4,1 do
		for i = -k,k,2*k do
			for j = -k,k,2*k do
				if nodes[area:index(pos.x+i, pos.y, pos.z+j)] ~= c_torch
				or minetest.get_node({x=pos.x+i, y=pos.y, z=pos.z+j}).param2 ~= 1 then
					return false
				end
			end
		end
		if nodes[area:index(pos.x, pos.y+k-3, pos.z)] ~= c_mese then
			return false
		end
	end
	print(string.format("[portal] checked after: %.2fs", os.clock() - t1))
	return true
end

local function desert_stoneport(pos)
	for i = -1,1,2 do
		for _, a in ipairs({0,2,6}) do
			if minetest.get_node({x=pos.x+i, y=pos.y+a, z=pos.z}).name ~= "default:desert_stone"
			or minetest.get_node({x=pos.x, y=pos.y+a, z=pos.z+i}).name ~= "default:desert_stone" then
				return false
			end
		end
		if minetest.get_node({x=pos.x+i, y=pos.y+1, z=pos.z}).name ~= "default:water_flowing"
		or minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z+i}).name ~= "default:water_flowing" then
			return false
		end
		for a = 3,5,1 do
			if minetest.get_node({x=pos.x+i, y=pos.y+a, z=pos.z}).name ~= "air"
			or minetest.get_node({x=pos.x, y=pos.y+a, z=pos.z+i}).name ~= "air" then
				return false
			end
		end
		if minetest.get_node({x=pos.x+i, y=pos.y+7, z=pos.z}).name ~= "default:water_source"
		or minetest.get_node({x=pos.x, y=pos.y+7, z=pos.z+i}).name ~= "default:water_source" then
			return false
		end
		for j = -1,1,2 do
			for _, a in ipairs({0,2,6}) do
				if minetest.get_node({x=pos.x+i, y=pos.y+a, z=pos.z+j}).name ~= "default:desert_stone" then
					return false
				end
			end
			if minetest.get_node({x=pos.x+i, y=pos.y+1, z=pos.z+j}).name ~= "default:mese"
			or minetest.get_node({x=pos.x+i, y=pos.y+7, z=pos.z+j}).name ~= "default:mese"
			or minetest.get_node({x=pos.x+i, y=pos.y+8, z=pos.z+j}).name ~= "default:torch"
			or minetest.get_node({x=pos.x+i, y=pos.y+8, z=pos.z+j}).param2 ~= 1 then
				return false
			end
			for a = 3,5,1 do
				if minetest.get_node({x=pos.x+i, y=pos.y+a, z=pos.z+j}).name ~= "default:wood" then
					return false
				end
			end
		end
	end
	for k = 1,6,1 do
		if minetest.get_node({x=pos.x, y=pos.y+k, z=pos.z}).name ~= "default:water_flowing" then
			return false
		end
	end
	for k = 2,3,1 do
		for i = -k,k,2*k do
			for j = -k,k,2*k do
				if minetest.get_node({x=pos.x+i, y=pos.y+3, z=pos.z+j}).name ~= "default:torch"
				or minetest.get_node({x=pos.x+i, y=pos.y+3, z=pos.z+j}).param2 ~= 1
				or minetest.get_node({x=pos.x+i, y=pos.y+5, z=pos.z+j}).name ~= "default:torch"
				or minetest.get_node({x=pos.x+i, y=pos.y+5, z=pos.z+j}).param2 ~= 0
				or minetest.get_node({x=pos.x+i, y=pos.y+2, z=pos.z+j}).name ~= "default:desert_stone"
				or minetest.get_node({x=pos.x+i, y=pos.y+6, z=pos.z+j}).name ~= "default:desert_stone" then
					return false
				end
			end
		end
	end
	return true
end

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "default:stick" then
		if node.name == "default:mese"
		and sandport({x=pos.x, y=pos.y-1, z=pos.z}) then
			minetest.sound_play("portal", {pos = pos,	gain = 0.5,	max_hear_distance = 5})
			minetest.add_particlespawner(
				300, --amount
				17, --time
				{x=pos.x-0.2, y=pos.y+0.5, z=pos.z-0.2}, --minpos
				{x=pos.x+0.2, y=pos.y+0.4, z=pos.z+0.2}, --maxpos
				{x=-0.2, y=-0, z=-0.2}, --minvel
				{x=0.2, y=0, z=0.2}, --maxvel
				{x=-0.5,y=4,z=-0.5}, --minacc
				{x=0.5,y=5,z=0.5}, --maxacc
				1, --minexptime
				10, --maxexptime
				1, --minsize
				9, --maxsize
				true, --collisiondetection
				"smoke_puff.png" --texture
			)
		elseif node.name == "default:desert_stone"
		and desert_stoneport(pos) then
			minetest.sound_play("portal", {pos = pos,	gain = 0.5,	max_hear_distance = 5})
			minetest.add_particlespawner(
				300, --amount
				17, --time
				{x=pos.x-0.2, y=pos.y+0.5, z=pos.z-0.2}, --minpos
				{x=pos.x+0.2, y=pos.y+0.4, z=pos.z+0.2}, --maxpos
				{x=-0.1, y=-0, z=-0.1}, --minvel
				{x=0.1, y=0, z=0.1}, --maxvel
				{x=-0.1,y=4,z=-0.1}, --minacc
				{x=0.1,y=5,z=0.1}, --maxacc
				1, --minexptime
				10, --maxexptime
				1, --minsize
				9, --maxsize
				true, --collisiondetection
				"smoke_puff.png" --texture
			)
		end
	end
end)
