# Empty C/C++ Project Template

A minimal, well-structured C/C++ project template with a production-ready makefile system. This template provides a quick starting point for new C/C++ projects with proper directory structure and build configuration.

## Quick Start

### Create Your Project

This is a template repository, which means you can create a new repository with the same directory structure and files very easily:

1. Click the "Use this template" button at the top right of the repository page
2. Choose "Create a new repository"
3. Fill in your repository name and other details
4. Click "Create repository" to finish

This will create a new repository in your account with all the template contents, giving you a fresh start for your project. Unlike forking, this method creates a clean project history.

### Build Your Project

After creating your repository from the template:

```bash
# Clone your new repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME

# Build the project
make

# Run the executable
./empty-cpp
```

### Clone and Build

Alternatively, you can fork this repository:

```bash
# Clone the repository
git clone https://github.com/rantalaine/empty-c-cpp.git
cd empty-c-cpp

# Build the project
make

# Run the executable
./empty-cpp
```

### Project Structure

```
empty-c-cpp/
├── src/          # Source files (.c, .cpp)
├── include/      # Header files (.h, .hpp)
├── build/        # Compiled object files (created during build)
├── makefile      # Build configuration
├── LICENSE       # MIT License
└── README.md     # Project documentation
```

## Makefile Explained

The makefile is designed to be flexible and maintainable while providing useful features for C/C++ development. Here are the key components:

### 1. Configuration Variables

```makefile
PROG_BIN := empty-cpp          # Name of the final executable
BUILD_DIR := ./build           # Where compiled files go
SRC_DIRS := ./src             # Where source files are located
INC_DIRS := ./include         # Where header files are located
```

### 2. Key Features

- **Automatic Directory Structure**
  - Automatically finds all `.c`, `.cpp`, and `.s` files in the source directory
  - Creates necessary build directories on-the-fly
  - Generates dependency files automatically

- **Platform Detection**
  ```makefile
  UNAME_S := $(shell uname -s)  # Detects operating system
  ```

- **Flexible Include Paths**
  - Supports both local and system include directories
  - Easy to add new include paths (just add to `INC_DIRS`)

- **Dependency Tracking**
  - Automatically generates `.d` files to track header dependencies
  - Only rebuilds what's necessary when files change

### 3. Build Targets

- **default**: Builds the executable
  ```bash
  make
  ```

- **clean**: Removes build artifacts and executable
  ```bash
  make clean
  ```

- **install**: Installs the program to system (requires appropriate permissions)
  ```bash
  sudo make install
  ```

- **uninstall**: Removes the installed program
  ```bash
  sudo make uninstall
  ```

### 4. Compiler Flags

```makefile
CPPFLAGS := $(INC_FLAGS) -MMD -MP -g $(CXXFLAGS)  # Compiler flags
```
- `-MMD -MP`: Generates dependency files
- `-g`: Includes debug information
- Additional flags can be added via `CXXFLAGS` environment variable

## Customization

1. **Change Project Name**:
   - Modify `PROG_BIN` in the makefile

2. **Add Libraries**:
   - Add library paths to `LIB_DIR`
   - Add link flags to `LDFLAGS`

3. **Add Include Directories**:
   - Add new paths to `INC_DIRS`

4. **Platform-Specific Settings**:
   ```makefile
   ifeq ($(UNAME_S),Darwin)
       # MacOS-specific settings
   endif
   ```

## Notes

- The makefile automatically detects source files, so you can just add new `.cpp` or `.c` files to the `src` directory
- Header files should go in the `include` directory
- The build system creates object files in the `build` directory, maintaining the same directory structure as your source files
