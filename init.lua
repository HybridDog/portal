local load_time_start = os.clock()
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
		if node.name == "default:desert_stone"
		and desert_stoneport(pos) then
--			minetest.sound_play("portal", {pos = pos,	gain = 0.5,	max_hear_distance = 5})
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
minetest.log("info", string.format("[portal] loaded after ca. %.2fs", os.clock() - load_time_start))
