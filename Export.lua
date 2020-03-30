--This code exports the height of the aircraft above the terrain to an IP adress.
--It is being exported at a specified interval. Modify the line 'tNext = tNext + 2.0' according to your needs.
--Just replace the '2.0' with the time interval in seconds. 

function LuaExportStart()

	package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
	package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"

	socket = require("socket")
	IPAddress = "127.0.0.1"
	Port = 31090

	MySocket = socket.try(socket.connect(IPAddress, Port))
	MySocket:setoption("tcp-nodelay",true) 
end

function LuaExportBeforeNextFrame()
end

function LuaExportAfterNextFrame()
	
	--/////////////// your code starts here //////////////////////////
	local RALT = LoGetAltitudeAboveGroundLevel()
	local IAS = LoGetIndicatedAirSpeed()
	--local AoA = LoGetAngleofAttack()	--Typo!
	local AoA = LoGetAngleOfAttack()
	local mach = LoGetMachNumber()
	local ss = LoGetSlipBallPosition()

	
	--socket.try(MySocket:send(string.format("RadAlt [m]: %.4f \t IAS: %.4f \t AoA: %.4f\n”,RALT, IAS, AoA)))
	socket.try(MySocket:send(string.format("RadAlt [m]: %.4f \t IAS: %.4f \t AoA: %.4f	\t Mach: %.4f \t ss: %.4f\n",RALT, IAS, AoA, mach, ss)))
	--/////////////// your code ends here ////////////////////////////
	
end

function LuaExportStop()

	if MySocket then 
		socket.try(MySocket:send("exit"))
		MySocket:close()
	end
end

function LuaExportActivityNextEvent(t)
end
