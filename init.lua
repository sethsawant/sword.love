local init = {}

function init.loadConfig()   --function to handle config file
  config = io.open("config.ini", "r") -- attempts to open config
  if (io.open("config.ini", "r") == nil) then -- if it doesnt exist
    config = io.open("config.ini", "w")       -- creates a new one
    config:write("config.ini")  --populates file
    return false                              --returns false
  else
    return true                               --otherwise returns true
  end
end

return init
