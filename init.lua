local function sandport(pos)
	for i = -1,1,2 do
		for j = -1,1,2 do
			if minetest.env:get_node({x=pos.x+i, y=pos.y+2, z=pos.z+j}).name ~= "default:torch"
			or minetest.env:get_node({x=pos.x+i, y=pos.y+2, z=pos.z+j}).param2 ~= 1
			or minetest.env:get_node({x=pos.x+i, y=pos.y+1, z=pos.z+j}).name ~= "default:sand"
			or minetest.env:get_node({x=pos.x+i, y=pos.y, z=pos.z+j}).name ~= "default:sand" then
				return false
			end
		end
		if minetest.env:get_node({x=pos.x+i, y=pos.y-2, z=pos.z+i*2}).name ~= "default:mese"
		or minetest.env:get_node({x=pos.x+i*2, y=pos.y-2, z=pos.z+i}).name ~= "default:mese"
		or (not minetest.registered_nodes[minetest.env:get_node({x=pos.x+i*2, y=pos.y-1, z=pos.z}).name].walkable)
		or (not minetest.registered_nodes[minetest.env:get_node({x=pos.x, y=pos.y-1, z=pos.z+i*2}).name].walkable)
		or minetest.env:get_node({x=pos.x+i, y=pos.y, z=pos.z}).name ~= "default:sand"
		or minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+i}).name ~= "default:sand"
		or minetest.env:get_node({x=pos.x+i*2, y=pos.y, z=pos.z}).name ~= "default:water_source"
		or minetest.env:get_node({x=pos.x, y=pos.y, z=pos.z+i*2}).name ~= "default:water_source" then
			return false
		end
	end
	for k = 3,4,1 do
		for i = -k,k,2*k do
			for j = -k,k,2*k do
				if minetest.env:get_node({x=pos.x+i, y=pos.y, z=pos.z+j}).name ~= "default:torch"
				or minetest.env:get_node({x=pos.x+i, y=pos.y, z=pos.z+j}).param2 ~= 1 then
					return false
				end
			end
		end
		if minetest.env:get_node({x=pos.x, y=pos.y+k-3, z=pos.z}).name ~= "default:mese" then
			return false
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
		end
	end
end)

