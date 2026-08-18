# Default to current directory if no DIR is specified
DIR ?= .

CFLAGS = -std=c++20 -Wall -fdiagnostics-color=always -g
LDFLAGS = -lglfw -lvulkan -ldl -lpthread

GLSLC = glslc

# File paths
TARGET = $(DIR)/main
SRC = $(DIR)/main.cpp

# Shaders live in DIR/shaders/, compiled SPIR-V goes alongside them
SHADER_DIR = $(DIR)/shaders
VERT_SRCS := $(wildcard $(SHADER_DIR)/*.vert)
FRAG_SRCS := $(wildcard $(SHADER_DIR)/*.frag)
SPV_OBJS  := $(VERT_SRCS:.vert=.vert.spv) $(FRAG_SRCS:.frag=.frag.spv)

# Default rule builds compiled shaders and the executable
all: $(SPV_OBJS) $(TARGET)

# Compile C++ executable
$(TARGET): $(SRC)
	g++ $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

# Compile vertex/fragment shaders to SPIR-V
$(SHADER_DIR)/%.vert.spv: $(SHADER_DIR)/%.vert
	$(GLSLC) $< -o $@

$(SHADER_DIR)/%.frag.spv: $(SHADER_DIR)/%.frag
	$(GLSLC) $< -o $@

.PHONY: all run clean

run: all
	# Force Wayland native execution
	cd $(DIR) && GLFW_PLATFORM=wayland ./$(notdir $(TARGET))

clean:
	rm -f $(TARGET) $(SHADER_DIR)/*.spv