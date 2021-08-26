-- Variables
settings = {
	-- Customization options
	color = '#f0c850';

	position = {
		-- 0:100
		offsetX = 17;
		offsetY = 2.5; 
	};

  scale = 1.0;

	vehicleCheck = false; -- Rather or not to display HUD when player(s) are inside a vehicle
  dynamic = false;
}

local directions = {
  N = 360, 0,
  NE = 315,
  E = 270,
  SE = 225,
  S = 180,
  SW = 135,
  W = 90,
  NW = 45
  --  N = 0, <= will result in the HUD breaking above 315deg
}

local veh = 0;
local hash1, hash2, heading;

Citizen.CreateThread(function()

	-- Wait a single second before sending data NUI message :? 
	Citizen.Wait(1000);

	SendNUIMessage({
		type = 'streetLabel:DATA',
    color = settings.color,
		offsetX = settings.position.offsetX,
		offsetY = settings.position.offsetY,
    scale = settings.scale,
    dynamic = settings.dynamic
	});

	while true do
		local ped = GetPlayerPed(-1);
		local veh = GetVehiclePedIsIn(ped, false);

		local coords = GetEntityCoords(PlayerPedId());
		local zone = GetNameOfZone(coords.x, coords.y, coords.z);
		local zoneLabel = GetLabelText(zone);

		if(settings.vehicleCheck == false or veh ~= 0) then 
			local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
			hash1 = GetStreetNameFromHashKey(var1);
			hash2 = GetStreetNameFromHashKey(var2);
			heading = GetEntityHeading(PlayerPedId());
			
			for k, v in pairs(directions) do
				if (math.abs(heading - v) < 22.5) then
					heading = k;
		  
					if (heading == 1) then
						heading = 'N';
						break;
					end

					break;
				end
			end

			local street2;
			if (hash2 == '') then
				street2 = zoneLabel;
			else
				street2 = hash2..', '..zoneLabel;
			end

			SendNUIMessage({
				type = 'streetLabel:MSG',
				active = true,
				direction = heading,
				street = hash1,
				zone = street2
			});
		else
			SendNUIMessage({
				type = 'streetLabel:MSG',
				active = false
			});
		end
		
		-- Wait for half a second.
		Citizen.Wait(500);
		
	end
end)