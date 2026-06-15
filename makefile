# Directories
SRC_DIR := src
INCLUDE_DIR := include
LIB_DIR := lib
BUILD_DIR := build

# Compiler settings
AS := asm
CC := gcc
CXX := g++

# Compiler flags
ASFLAGS := -Wall -Werror -g
CFLAGS := -Wall -Werror -g
CXXFLAGS := -Wall -Werror -g

# Linker settings
LDFLAGS := -L $(LIB_DIR)/ -static

# Target executable
TARGET := ReplaceWithProjectName

# Build and objects directories
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj

# Find source files
ifeq ($(OS),Windows_NT)
	#SRCS := $(wildcard $(SRC_DIR)/*.cpp $(SRC_DIR)/*.c $(SRC_DIR)/*.s)
	#SRCS := $(wildcard *.cpp *.c *.s)
	SRCS := $(shell dir /b $(SRC_DIR)\*.c*)
else
	SRCS := $(shell find $(SRC_DIR) -name '*.c*')
endif
OBJS := $(SRCS:%=$(OBJ_DIR)/%.o)
DEPS := $(OBJS:.o=.d)


# Default build target
.PHONY: all compile build
all: compile build

build: $(BIN_DIR)/$(TARGET)

# compile: $(OBJ_DIR)/%.cpp.o $(OBJ_DIR)/%.c.o $(OBJ_DIR)/%.s.o
compile: $(OBJS)
	
-include $(DEPS)

# Linking
$(BIN_DIR)/$(TARGET): $(OBJS)
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else	
	@mkdir -p $(@D) # Linux
endif	
	$(CXX) $^ -o $@ $(LDFLAGS)

# Compiling Cpp
$(OBJ_DIR)/%.cpp.o: $(SRC_DIR)/%.cpp 
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D) # Linux
endif
	$(CXX) -c $< $(CXXFLAGS) -MMD -MP -I $(INCLUDE_DIR)/ -o $@

# Compiling C
$(OBJ_DIR)/%.c.o: $(SRC_DIR)/%.c
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D) # Linux
endif
	$(CC) -c $< $(CFLAGS) -MMD -MP -I $(INCLUDE_DIR)/ -o $@

# Compiling Assembly
$(OBJ_DIR)/%.s.o: $(SRC_DIR)/%.s
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D)
endif
	$(AS) $< $(ASFLAGS) -o $@

# Shows sources, objects and objects folder, useful to debug
show:
	@echo SRCS:
	@echo $(SRCS)
	@echo OBJS:
	@echo $(OBJS)
	@echo OBJ_DIR:
	@echo $(OBJ_DIR)

# Clean
.PHONY: clean
clean:
ifeq ($(OS),Windows_NT)
	rmdir /S /Q $(BUILD_DIR)
else
	rm -rf $(BUILD_DIR) #Linux
endif

# Run
.PHONY: run
run:
	./$(BIN_DIR)/$(TARGET)
