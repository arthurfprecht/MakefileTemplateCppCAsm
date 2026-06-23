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
CFLAGS := -Wall -Werror -g -std=c++17
CXXFLAGS := -Wall -Werror -g -std=c++17

# Linker settings
LDFLAGS := -L $(LIB_DIR)/ -static

# Target executable
TARGET := RK4solver

# Build and objects directories
BIN_DIR := $(BUILD_DIR)/bin
OBJ_DIR := $(BUILD_DIR)/obj

# Find source files
SRCS_CXX := $(wildcard $(SRC_DIR)/*.cpp $(SRC_DIR)/**/*.cpp)
OBJS_CXX := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.cpp.o,$(SRCS_CXX))

SRCS_C := $(wildcard $(SRC_DIR)/*.c $(SRC_DIR)/**/*.c)
OBJS_C := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.c.o,$(SRCS_C))

SRCS_ASM := $(wildcard $(SRC_DIR)/*.s $(SRC_DIR)/**/*.s)
OBJS_ASM := $(patsubst $(SRC_DIR)/%.s,$(OBJ_DIR)/%.s.o,$(SRCS_ASM))

DEPS := $(OBJS:.o=.d)

# Default build target
.PHONY: all compile build
all: compile build

build: $(BIN_DIR)/$(TARGET)

compile: $(OBJS_CXX) $(OBJS_C) $(OBJS_ASM)

-include $(DEPS)

# Linking
$(BIN_DIR)/$(TARGET): $(OBJS_CXX) $(OBJS_C) $(OBJS_ASM)
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else	
	@mkdir -p $(@D) # Linux
endif	
	$(CXX) $^ -o $@ $(LDFLAGS)

# Compiling Cpp
$(OBJ_DIR)/%.cpp.o : $(SRC_DIR)/%.cpp
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D) # Linux
endif
	$(CXX) -c $< $(CXXFLAGS) -MMD -MP -I $(INCLUDE_DIR)/ -o $@

# Compiling C
$(OBJ_DIR)/%.c.o : $(SRC_DIR)/%.c
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D) # Linux
endif
	$(CC) -c $< $(CFLAGS) -MMD -MP -I $(INCLUDE_DIR)/ -o $@

# Compiling Assembly
$(OBJ_DIR)/%.s.o : $(SRC_DIR)/%.s
ifeq ($(OS),Windows_NT)
	if not exist "$(@D)" mkdir "$(@D)"
else
	@mkdir -p $(@D)
endif
	$(AS) $< $(ASFLAGS) -o $@

# Shows sources, objects and objects folder, useful to debug
.PHONY: show
show:
	@echo SRCS_CXX:
	@echo $(SRCS_CXX)
	@echo OBJS_CXX:
	@echo $(OBJS_CXX)
	@echo SRCS_C:
	@echo $(SRCS_C)
	@echo OBJS_C:
	@echo $(OBJS_C)
	@echo SRCS_ASM:
	@echo $(SRCS_ASM)
	@echo OBJS_ASM:
	@echo $(OBJS_ASM)
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
