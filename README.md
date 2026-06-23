# MakefileTemplateCppCAsm

This is a simple makefile template for C++, C or Assembly in Windows/Linux. To use, simply change the TARGET from "ReplaceWithProjectName" to the desired project name

## Functionality

- all: compile and build to generate the executable
- compile: Only compiles source files, does not link
- build: Links built files to generate executable
- show: shows some variables, useful for debugging
- clean: cleans all build products by deleting the build folder
- run: executes the built target

## Recommended folder structure
<pre>
project_folder  
|  
|---- build (will be created automatically, or deleted with clean)  
|      |  
|      |---- bin (executable will be here, folder is created automatically)  
|      |  
|      |---- obj (other .o will be here, folder is created automatically)  
|  
|---- src  
|      |---- subfolder_1
|      |  
|      |---- subfolder_2
|  
|---- include  
|  
|---- lib  
</pre>
