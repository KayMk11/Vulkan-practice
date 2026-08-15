# Default to current directory if no DIR is specified
DIR ?= .

CFLAGS = -std=c++20 -Wall -fdiagnostics-color=always -g
LDFLAGS = -lglfw -lvulkan -ldl -lpthread

SLANGC = slangc
SLANGFLAGS = -target spirv

# File paths
TARGET = $(DIR)/main
SRC = $(DIR)/main.cpp

# Automatically detect any .slang files in the specified DIR
SLANG_SRCS := $(wildcard $(DIR)/*.slang)
SPV_OBJS   := $(SLANG_SRCS:.slang=.spv)

# Default rule builds compiled shaders (if any exist) and the executable
all: $(SPV_OBJS) $(TARGET)

# Compile C++ executable
$(TARGET): $(SRC)
	g++ $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

# Generic rule to compile any .slang file to .spv in the target DIR
%.spv: %.slang
	$(SLANGC) $< $(SLANGFLAGS) -o $@

.PHONY: all run clean

run: all
	# Force Wayland native execution
	cd $(DIR) && GLFW_PLATFORM=wayland ./$(notdir $(TARGET))

clean:
	rm -f $(TARGET) $(DIR)/*.spv