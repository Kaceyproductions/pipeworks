if (minetest.get_modpath("mesecons")) then
 	
	register_tube("pipeworks:mesecon_tube_on","Mesecon tube segment on (you hacker you)",mesecon_plain_textures,noctr_textures,
	end_textures,short_texture,mesecon_inv_texture,
	{tube={can_go=function(pos,node,velocity,stack)
		local meta = minetest.env:get_meta(pos)
		local name = minetest.env:get_node(pos).name
		local nitems=meta:get_int("nitems")+1
		meta:set_int("nitems", nitems)
		minetest.after(0.1,minetest.registered_nodes[name].item_exit,pos)
		return notvel(meseadjlist,velocity)
	end},
	groups={mesecon=2,not_in_creative_inventory=1},
	drop="pipeworks:detector_tube_off_000000",
	mesecons={conductor={state="on",
				rules=mesecons_rules}},
	item_exit = function(pos)
		local meta = minetest.env:get_meta(pos)
		local nitems=meta:get_int("nitems")-1
		local name = minetest.env:get_node(pos).name
		if nitems==0 then
			minetest.env:set_node(pos,{name=string.gsub(name,"on","off")})
			mesecon:conductor_off(pos,mesecons_rules)
		else
			meta:set_int("nitems", nitems)
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("nitems", 1)
		local name = minetest.env:get_node(pos).name
		minetest.after(0.1,minetest.registered_nodes[name].item_exit,pos)
	end})

	register_tube("pipeworks:mesecon_tube_off","Mesecon tube segment",mesecon_plain_textures,noctr_textures,
	end_textures,short_texture,mesecon_inv_texture,
	{tube={can_go=function(pos,node,velocity,stack)
		local name = minetest.env:get_node(pos).name
		minetest.env:set_node(pos,{name=string.gsub(name,"off","on")})
		mesecon:conductor_on(pos,mesecons_rules)
		return notvel(meseadjlist,velocity)
	end},
	groups={mesecon=2},
	mesecons={conductor={state="off",
				onstate = "pipeworks:mesecon_tube_on",
				offstate = "pipeworks:mesecon_tube_off",
				rules=mesecons_rules}}
	end})
end	