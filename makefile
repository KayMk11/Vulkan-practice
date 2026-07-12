# Default to current directory if no DIR is specified
DIR ?= .

CFLAGS = -std=c++20 -Wall -fdiagnostics-color=always -g
LDFLAGS = -lglfw -lvulkan -ldl -lpthread

# The target binary will be placed inside the specified folder
TARGET = $(DIR)/main
SRC = $(DIR)/main.cpp

$(TARGET): $(SRC)
	g++ $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

.PHONY: run clean

run: $(TARGET)
	# Force Wayland native execution
	GLFW_PLATFORM=wayland ./$(TARGET)

clean:
	rm -f $(TARGET)


