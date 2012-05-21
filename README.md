#LCS : Lua Class System#
*Lua Class System* (LCS) is a small library which offers a clean, minimalistic but powerful API for (Pseudo) Object Oriented programming style using Lua.
LCS is light-weight, abstract thus can fit in every project where OOP mechanisms are needed.

  
##Usage##
Add 'LCS.lua' file inside your project.
Call it using require command.
It will return a table containing a set of functions.
	
##Full API Overview##
		LCS.class(args)  : Creates a class
		LCS.class.final(args)  : Creates a final class.
		LCS.class.abstract(args)  : Creates a static class.
		LCS.is_A(thing,kind)  : Checks the nature of the given argument 'thing'.
		
		[class](args) : Default class constructor used for instantiation.
		[class]:new(args) : Same as [class](args)
		[class]:extends(args) : Returns a new class derived from class [class].
		[class]:getClass() : Returns a reference to the superclass of class [class] 
		[class]:getSubClasses() : Returns a list of all classes deriving from class [class] 
		[class]:super(method,...) : Calls a method defined in a parent of class [class]
		
		[instance]:getClass() : Returns a reference to the class from which 'instance' was created
		[instance]:is_A(aClass) : 	Checks if instance [instance] was instantiated from a specific class.
		[instance]:super(method,...) : 	Calls a methods defined in a parent of a class from which object 'instance' was created 
		
##Documentation##
* Full Documentation is available, with example code: [Documentation][].
* Tests have also been included : See [Tests.lua][]
* A quickTour have been included : See [quickTour.lua][]
* Documentation was generated thanks to [LuaDoc][].

		
##License##
This work is under [zLIB License][]
Copyright (c) 2012 Roland Yonaba

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

[Documentation]: https://github.com/Yonaba/Lua-Class-System/downloads
[Tests.lua]: https://github.com/Yonaba/Lua-Class-System/blob/master/tests.lua
[quickTour.lua]: https://github.com/Yonaba/Lua-Class-System/blob/master/quickTour.lua
[LuaDoc]: http://keplerproject.github.com/luadoc/
[zLIB License]: http://www.opensource.org/licenses/zlib-license.php