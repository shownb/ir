--sony irc http://picprojects.org.uk/projects/sirc/sonysirc.pdf
--the ir codes database http://irdb.tk
--dofile("ir.lua").sendRaw(38,{1032,563,595,554,596,1385,606,1377,617,536,614,1379,615,535,615,1374,615,541,610,1379,614,1376,617},23)
--http://www.esp8266.com/viewtopic.php?f=24&t=1486
--https://github.com/nodemcu/nodemcu-firmware/issues/177
local M
do
	local gpio = gpio
	local mode, write = gpio.mode, gpio.write
	local waitus = tmr.delay
	local irpin = 6
	local halfPeriodicTime

	local function enableIROut(khz)
		halfPeriodicTime = 500/khz
	end

	local function mark(mtime)
		local begin=tmr.now()
		while(tmr.now()-begin<mtime)
			do
				write(irpin,1)
				waitus(halfPeriodicTime)
				write(irpin,0)
				waitus(halfPeriodicTime)
			end
	end

	local function space(mtime)
		write(irpin,0)
		waitus(mtime)
	end

	local function sendRaw(khz,rawData,len)
		mode(irpin,1)
		enableIROut(khz)
		for i=1,len do
			if (i%2==0) then
				space(rawData[i])
			else
				mark(rawData[i])
			end
		end
	end

	local function sendNec()
		print("test")
	end

	M = {
		sendRaw=sendRaw,
		sendNec=sendNec,
	}
end

return M


