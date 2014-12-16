cmake_minimum_required(VERSION 2.8.4)
project(frequensea)

if (APPLE)
    include_directories(/System/Library/Frameworks /usr/local/include)
    find_library(FRAMEWORK_COCOA Cocoa)
    find_library(FRAMEWORK_OPENGL OpenGL)
    find_library(FRAMEWORK_CORE_VIDEO CoreVideo)
    find_library(FRAMEWORK_IO_KIT IOKit)
    find_library(LIBRARY_GLFW glfw3)
    find_library(LIBRARY_LUA lua)
    set(EXTRA_LIBS ${FRAMEWORK_COCOA} ${FRAMEWORK_OPENGL} ${FRAMEWORK_CORE_VIDEO} ${FRAMEWORK_IO_KIT} ${LIBRARY_GLFW} ${LIBRARY_LUA})
endif (APPLE)

set(SOURCE_FILES
    src/main.c
    src/nfile.c
    src/ngl.c
    src/noise.c
    src/nwm.c
    src/obj.c
    src/vec.c)
add_executable(frequensea ${SOURCE_FILES})
target_link_libraries(frequensea ${EXTRA_LIBS})