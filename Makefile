# Makefile for Inventory Management System
# Author: Team Lead
# Date: 2024

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -g -O2
INCLUDES = -Iinclude
LDFLAGS = 

# Directories
SRC_DIR = src
INCLUDE_DIR = include
BUILD_DIR = build
DATA_DIR = data

# Source files
SOURCES = $(SRC_DIR)/main.c \
          $(SRC_DIR)/item.c \
          $(SRC_DIR)/supplier.c \
          $(SRC_DIR)/transaction.c \
          $(SRC_DIR)/storage.c \
          $(SRC_DIR)/menu.c \
          $(SRC_DIR)/utils.c

# Object files
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

# Executable name
TARGET = ims

# Default target
all: $(TARGET)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Create data directory
$(DATA_DIR):
	mkdir -p $(DATA_DIR)

# Compile object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Link executable
$(TARGET): $(OBJECTS) | $(DATA_DIR)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build completed successfully!"
	@echo "Run './$(TARGET)' to start the program"

# Clean build files
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET)
	@echo "Clean completed"

# Clean data files (use with caution!)
clean-data:
	rm -rf $(DATA_DIR)
	@echo "Data files cleaned"

# Clean everything
clean-all: clean clean-data
	@echo "All files cleaned"

# Install (copy executable to system path)
install: $(TARGET)
	cp $(TARGET) /usr/local/bin/
	@echo "Installed to /usr/local/bin/"

# Uninstall
uninstall:
	rm -f /usr/local/bin/$(TARGET)
	@echo "Uninstalled from /usr/local/bin/"

# Run the program
run: $(TARGET)
	./$(TARGET)

# Debug build
debug: CFLAGS += -DDEBUG -g3
debug: $(TARGET)

# Release build
release: CFLAGS += -DNDEBUG -O3
release: clean $(TARGET)

# Check for memory leaks (requires valgrind)
memcheck: $(TARGET)
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGET)

# Format code (requires clang-format)
format:
	find $(SRC_DIR) $(INCLUDE_DIR) -name "*.c" -o -name "*.h" | xargs clang-format -i
	@echo "Code formatted"

# Static analysis (requires cppcheck)
analyze:
	cppcheck --enable=all --inconclusive --std=c99 $(SRC_DIR) $(INCLUDE_DIR)
	@echo "Static analysis completed"

# Create documentation (requires doxygen)
docs:
	doxygen Doxyfile
	@echo "Documentation generated"

# Package the project
package: clean
	tar -czf ims-project.tar.gz src include Makefile README.md
	@echo "Project packaged as ims-project.tar.gz"

# Help target
help:
	@echo "Available targets:"
	@echo "  all        - Build the project (default)"
	@echo "  clean      - Remove build files"
	@echo "  clean-data - Remove data files (use with caution!)"
	@echo "  clean-all  - Remove all generated files"
	@echo "  run        - Build and run the program"
	@echo "  debug      - Build with debug information"
	@echo "  release    - Build optimized release version"
	@echo "  memcheck   - Run with valgrind memory checker"
	@echo "  format     - Format source code"
	@echo "  analyze    - Run static analysis"
	@echo "  docs       - Generate documentation"
	@echo "  package    - Create project package"
	@echo "  install    - Install to system"
	@echo "  uninstall  - Remove from system"
	@echo "  help       - Show this help message"

# Phony targets
.PHONY: all clean clean-data clean-all install uninstall run debug release memcheck format analyze docs package help

# Default target
.DEFAULT_GOAL := all
