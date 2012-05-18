-- Copyright (c) 2012 Roland Yonaba
--[[
This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
--]]

local pairs,ipairs = pairs,ipairs
local assert = assert
local setmetatable, getmetatable = setmetatable, getmetatable
local insert = table.insert

local baseClassMt = {__call = function (self,...) return self:new(...) end}
local Class

-- Simple helper for building a raw copy of a table
-- Only pointers to classes or objects stored as instances are preserved
local function deep_copy(t)
	local r = {}
	for k,v in pairs(t) do
		if type(v) == 'table' then
			if (v.__system) then
				r[k] = v
			else
				r[k] = deep_copy(v)
			end
		else
			r[k] = v
		end
	end
	return r
end

-- Checks if thing is a kind or whether an 'object' or 'class'
local function isA(thing,kind)
	if kind then
		assert(kind == 'object' or kind == 'class','When given, string \'kind\' must be either \'class\' or \'object\'')
	end
	if thing and thing.__system  then
		return kind and (thing.__system.__type == kind) or thing.__system.__type
	end
	return false
end

-- Instantiation
local function instantiateFromClass(self,...)
	assert(isA(self,'class'),'Class constructor must be called from a class')
	assert(not self.__system.__static, 'Cannot instantiate from a static class')
	local instance = setmetatable({__system = {__type = 'object',__superClass = self}},self)
		if self.init then
			self.init(instance, ...)
		end
	return instance
end

-- Class derivation
local function extendsFromClass(self,extra_params)
	assert(isA(self,'class'),'Inheritance must be called from a class')
	assert(not self.__system.__final, 'Cannot derive from a final class')
	local class = Class(extra_params)
	class.__index = class
	class.__system.__superClass = self
	insert(self.__system.__subClass,class)
	return setmetatable(class,self)
end

-- Super methods call
local function callFromSuperClass(self,f,...)
	local super = getmetatable(self).__system.__superClass
	local method = super[f]
	return method(self,...)
end

-- Gets the superclass
local function getSuperClass(self)
	local super = getmetatable(self)
	return (super ~= baseClassMt and super or nil)
end

-- Gets the subclasses
local function getSubClasses(self)
	assert(isA(self,'class'),'getSubClasses() must be called from class')
	return self.__system.__subClass or {}
end

-- Class creation
Class = function(members)

	local newClass = members and deep_copy(members) or {}                              -- includes class variables
	newClass.__index = newClass                                                        -- prepares class for inheritance
	newClass.__system = {                                                              -- builds information for internal handling
		__type = "class",
		__static = static or false,
		__final = final or false,
		__superClass = false,
		__subClass = {},
	}

	newClass.new = instantiateFromClass                                                -- class instanciation
	newClass.extends = extendsFromClass                                                -- class derivation
	newClass.__call = baseClassMt.__call                                               -- shortcut for instantiation with class() call
	newClass.super = callFromSuperClass                                                -- super method calls handling
	newClass.getClass = getSuperClass                                                  -- gets the superclass
	newClass.getSubClasses = getSubClasses                                             -- gets the subclasses

	newClass.is_A = function(self,aClass)                                              -- Object's class checking
		assert(isA(self,'object'),'is_A() must be called from an object')
		if aClass then
			assert(isA(aClass,'class'),'When given, Argument must be a class')
		end
		return (aClass and self:getClass() == aClass or self:getClass())
	end

	return setmetatable(newClass,baseClassMt)
end

-- Static classes
local function staticClass(members)
	local class = Class(members)
	class.__system.__static = true
	return class
end

-- Final classes
local function finalClass(members)
	local class = Class(members)
	class.__system.__final = true
	return class
end

-- Returns utilities packed in a table (in order to avoid polluting the global environment)
return  {
			_VERSION = "0.1",
			is_A = isA,
			class = setmetatable({ static = staticClass, final = finalClass},{__call = function(self,...) return Class(...) end}),
		}
