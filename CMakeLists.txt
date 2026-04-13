cmake_minimum_required(VERSION 3.11)

project(dottracker
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23)

# Target executable

file(GLOB_RECURSE SOURCE_FILES
    CONFIGURE_DEPENDS src/*.cxx)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})

target_compile_options(${PROJECT_NAME}
    PRIVATE -Wall -Wextra -pedantic)

target_include_directories(${PROJECT_NAME}
    PRIVATE include)
