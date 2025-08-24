local SuperStatic = {}

local SuperPublicInstanceMethods = {}
local SuperProtectedInstanceMethods = {} 
local SuperPrivateInstanceMethods = {}

SuperStatic.inheritables = {
	publicMethods = setmetatable({}, {__index = SuperPublicInstanceMethods}),
	protectedMethods = setmetatable({}, {__index = SuperProtectedInstanceMethods})
}

export type PublicInstanceVariables = {}
export type ProtectedInstanceVariables = {}
type SuperPrivateInstanceVariables = {}
type SuperInstanceVariables = PublicInstanceVariables &
							  ProtectedInstanceVariables &
							  SuperPrivateInstanceVariables

type Super = typeof(SuperPublicInstanceMethods) &
			 PublicInstanceVariables
type SuperProtected = Super &
					  typeof(SuperProtectedInstanceMethods) &
					  ProtectedInstanceVariables
type SuperPrivate = SuperProtected &
					typeof(SuperPrivateInstanceMethods) &
					SuperPrivateInstanceVariables

local function multiIndex(...: {[any]: any} | (any, any)->any): (any, any)->any
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

function SuperStatic.new(): Super
	local instance: SuperInstanceVariables = {}

	return (setmetatable(
		instance,
		{__index = multiIndex(
			SuperPublicInstanceMethods,
			SuperProtectedInstanceMethods,
			SuperPrivateInstanceMethods
		)}
	) :: any) :: Super
end

return SuperStatic