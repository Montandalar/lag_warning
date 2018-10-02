
local function explode(sep, input)
        local t={}
        local i=0
        for k in string.gmatch(input,"([^"..sep.."]+)") do 
            t[i]=k
            i=i+1
        end
        return t
end

local function get_max_lag()
        local arrayoutput = explode(", ",minetest.get_server_status())
        local arrayoutput = explode("=",arrayoutput[4])
        return arrayoutput[1]
end

-- lag

local min_lag
local max_lag

min_lag = 10
max_lag = 0

minetest.register_globalstep(function(dtime)
	if dtime > max_lag then
		max_lag = dtime
	end

	if dtime < min_lag then
		min_lag = dtime
	end
end)


-- generated blocks (80x80)

local generated_count

generated_count = 0

minetest.register_on_generated(function(minp, maxp, seed)
	generated_count = generated_count + 1
end)


-- display



local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then return end
	timer=0

	if generated_count > 0 and max_lag > 1 then
		local lag = tonumber(get_max_lag())

		minetest.chat_send_all("# Server-Message #: Mapgen is at work right now, prepare for some lag (" ..
			"Current: " .. lag .. "s, " ..
			"Max: " .. max_lag .. "s, " ..
			"Chunks: " .. generated_count .. ")")
	end

	min_lag = 10
	max_lag = 0
	generated_count = 0
end)




