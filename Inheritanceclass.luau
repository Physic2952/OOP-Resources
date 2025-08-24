local Super = require(shared.Superclass)

local ClassStatic = {}
setmetatable(ClassStatic, {__index = Super}) 

local ClassPublicInstanceMethods = setmetatable(
	{}, {__index = Super.inheritables.publicMethods}
)
local ClassProtectedInstanceMethods = setmetatable(
	{}, {__index = Super.inheritables.protectedMethods}
)

local ClassPrivateInstanceMethods = {}

ClassStatic.inheritables = {}

type ClassPublicInstanceVariables = Super.PublicInstanceVariables & {}
type ClassProtectedInstanceVariables = Super.ProtectedInstanceVariables & {}
type ClassPrivateInstanceVariables = {}
type ClassInstanceVariables = ClassPublicInstanceVariabl6es &
							  ClassProtectedInstanceVariables &
							  ClassPrivateInstanceVariables

type Class = typeof(ClassPublicInstanceMethods) &
					ClassPublicInstanceVariables
type ClassProtected = Class &
						typeof(ClassProtectedInstanceMethods) &
						ClassProtectedInstanceVariables
type ClassPrivate = ClassProtected &
					typeof(ClassPrivateInstanceMethods) &
					ClassPrivateInstanceVariables

function ClassStatic.new(): Class
	local instance: ClassInstanceVariables = {}

	return (setmetatable(
		instance,
		{__index = multiIndex(
			ClassPublicInstanceMethods,
			ClassProtectedInstanceMethods,
			ClassPrivateInstanceMethods
		)}
	) :: any) :: Class
end