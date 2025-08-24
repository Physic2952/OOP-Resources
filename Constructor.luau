local ExampleStatic = {}

local ExamplePublicInstanceMethods = {}
local ExampleProtectedInstanceMethods = {}
local ExamplePrivateInstanceMethods = {}

type ExamplePublicInstanceVariables = { name: string }
type ExampleProtectedInstanceVariables = { level: number }
type ExamplePrivateInstanceVariables = { secret: string }

type ExampleInstanceVariables = ExamplePublicInstanceVariables &
                               ExampleProtectedInstanceVariables &
                               ExamplePrivateInstanceVariables
    
type Example = typeof(ExamplePublicInstanceMethods) & ExamplePublicInstanceVariables
type ExampleProtected = Example &
                       typeof(ExampleProtectedInstanceMethods) &
                       ExampleProtectedInstanceVariables
type ExamplePrivate = ExampleProtected &
                      typeof(ExamplePrivateInstanceMethods) &
                      ExamplePrivateInstanceVariables

local function multiIndex(...: {[any]: any} | (any, any) -> any): (any, any) -> any
    local indexables = {...}
    return function(object: any, index: any): any
        for _, indexable in ipairs(indexables) do
            local v: any
            if type(indexable) == "function" then
                v = indexable(object, index)
            else
                v = indexable[index]
            end
            if v then return v end
        end
        return nil
    end
end

function ExampleStatic.new(name: string, secret: string): Example
    local instance: ExampleInstanceVariables = {
        name = name,       -- public
        level = 1,         -- protected
        secret = secret,   -- private
    }

    return (setmetatable(
        instance,
        {__index = multiIndex(
            ExamplePublicInstanceMethods,
            ExampleProtectedInstanceMethods,
            ExamplePrivateInstanceMethods
        )}
    ) :: any) :: Example
end

function ExamplePublicInstanceMethods:greet()
    print("Hi, my name is " .. self.name)
    
    local selfFull = self :: ExamplePrivate
    print("My secret is: " .. selfFull.secret)
end

function ExampleProtectedInstanceMethods:levelUp()
    self.level += 1
    print("Level up! New level: " .. self.level)
end

function ExamplePrivateInstanceMethods:revealSecret()
    print("Revealing secret: " .. self.secret)
end

local obj = ExampleStatic.new("Alice", "I love Lua")

obj:greet()         
obj:levelUp()       
-- obj:revealSecret() 

return ExampleStatic
