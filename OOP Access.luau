local PlayerPublicMethods = {}
local PlayerProtectedMethods = {}
local PlayerPrivateMethods = {}

type PlayerPublicVars = {name : string}
type PlayerProtectedVars = {level: number}
type PlayerPrivateVars = {secretCode: string}

type Player = typeof(PlayerPublicMethods) & PlayerPublicVars
type PlayerProtected = Player & typeof(PlayerProtectedMethods) & PlayerProtectedVars
type PlayerPrivate = PlayerProtected & typeof(PlayerPrivateMethods) & PlayerPrivateVars

local function newPlayer(name: string, secretCode: string)
    local self = {
        name = name,           -- public
        level = 1,             -- protected
        secretCode = secretCode -- private
    }
    
    -- Mische alle Methoden
    for k,v in pairs(PlayerPublicMethods) do self[k] = v end
    for k,v in pairs(PlayerProtectedMethods) do self[k] = v end
    for k,v in pairs(PlayerPrivateMethods) do self[k] = v end
    
    return (self :: any) :: Player  
end

function PlayerPublicMethods:printName()
    print("Name: " .. self.name)
    
    
    local selfFull = self :: PlayerPrivate
    print("Secret Code: " .. selfFull.secretCode)  
end

function PlayerProtectedMethods:levelUp()
    self.level = self.level + 1
    print("Level up! New level: " .. self.level)
end

function PlayerPrivateMethods:getSecret()
    print("The secret code is: " .. self.secretCode)
end

local p = newPlayer("Alice", "XYZ123")
p:printName()         
p:levelUp()            
-- p:getSecret()       

