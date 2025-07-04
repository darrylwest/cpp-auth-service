# Gemini CLI Learnings for this project

This document summarizes key information and patterns learned during interactions with the Gemini CLI for the `egg-timer` project.

## Build System and Dependencies

- **CMake-based project:** The project uses CMake for its build system.
- **CPM for dependency management:** External C++ dependencies are managed using CPM.cmake.
- **Dependency Resolution Order:** When using CPM, the order of `CPMAddPackage` calls in `CMakeLists.txt` is crucial. If a dependency (e.g., `termio`) itself has a `find_package` call for another dependency (e.g., `Catch2`), the latter must be processed by CPM *before* the former.
- **Disabling Sub-project Tests:** To prevent sub-projects (like `cpp-termio`) from attempting to build or find their own test dependencies, use `CMAKE_ARGS "-DBUILD_TESTING=OFF"` within the `CPMAddPackage` call.
- **Global Library Paths in CI:** For libraries installed globally (e.g., `Catch2` via `apt-get` and `make install` in GitHub Actions), ensure `CMAKE_PREFIX_PATH` is set to `/usr/local` during the CMake configuration step to help CMake find the installed package configuration files.

## GitHub Actions Workflow (`.github/workflows/build-test-run.yml`)

- **Build Matrix:** The workflow uses a build matrix for `build_type` (e.g., `Release`).
- **Containerized Builds:** Builds run in a `darrylwest/ubuntu24-gpp1420:latest` Docker container.
- **System Dependencies:** `cmake`, `ninja-build`, and `git` are installed via `apt-get`.
- **Direct Unit Test Execution:** Unit tests are executed directly by running the compiled executable `./build/unit_tests` rather than using `ctest`.

## Local Development Workflow

- **Build Command:** The preferred local build command is `./mk all`. This command handles cleaning the build directory, configuring CMake, and building the project.
