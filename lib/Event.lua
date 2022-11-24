--|| KAZI

--// VARIABLES \\--
local Event = {}

--// EVENT \\--
function Event.new()
	local self = setmetatable({
		_Listeners = {},
		_Firing = false,
	}, {__index = Event})

	self.Event = self

	return self

end

function Event:Connect(Listener)
    self._Listeners[Listener] = true

	return {
		Disconnect = function()
			self._Listeners[Listener] = nil
		end,
	}
    
end

function Event:Fire(...)
	if self._Firing then
        return
	end

	self._Firing = true

	for Listener, _ in self._Listeners do
		local s, e = pcall(Listener, ...)

		if not s then
			warn(e)
		end

	end

	self._Firing = false

end
function Event:HardFire(...)
	for Listener, _ in self._Listeners do
		local s, e = pcall(Listener, ...)

		if not s then
			warn(e)
		end

	end

end


return Event