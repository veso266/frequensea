cmake_minimum_required(VERSION 2.8.4)
project(frequensea)

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --std=c99 -g -Wall -Werror -pedantic")

add_subdirectory(externals/lua)

include_directories(src)
include_directories(externals/ovr/Include)
include_directories(externals/ovr/Src)
include_directories(externals/lua/src)
include_directories(externals/stb)

find_library(LIBRARY_MATH m)
find_library(LIBRARY_PTHREAD pthread)
find_library(LIBRARY_FFTW fftw3)
find_library(LIBRARY_HACKRF hackrf)
find_library(LIBRARY_OVR ovr PATHS externals/ovr/Lib/Mac/Debug)
find_library(LIBRARY_PNG png)
find_library(LIBRARY_RTLSDR rtlsdr)
find_library(LIBRARY_GLEW glew)
set(CORE_LIBS ${LIBRARY_MATH} ${LIBRARY_PTHREAD} ${LIBRARY_FFTW} ${LIBRARY_GLFW} ${LIBRARY_HACKRF} ${LIBRARY_OVR} ${LIBRARY_PNG} ${LIBRARY_RTLSDR})

if (APPLE)
    include_directories(/System/Library/Frameworks /usr/local/include)
    find_library(FRAMEWORK_COCOA Cocoa)
    find_library(FRAMEWORK_OPENGL OpenGL)
    find_library(FRAMEWORK_OPENAL OpenAL)
    find_library(FRAMEWORK_CORE_VIDEO CoreVideo)
    find_library(FRAMEWORK_IO_KIT IOKit)
    find_library(LIBRARY_GLFW glfw3)
    set(PLATFORM_LIBS ${FRAMEWORK_COCOA} ${FRAMEWORK_OPENGL} ${FRAMEWORK_OPENAL} ${FRAMEWORK_CORE_VIDEO} ${FRAMEWORK_IO_KIT} ${LIBRARY_GLFW})
endif (APPLE)

if (LINUX)
    find_library(LIBRARY_GLFW glfw)
    set(PLATFORM_LIBS ${LIBRARY_GLFW})
endif (LINUX)

set(SOURCE_FILES
    src/main.cpp
    src/nfile.c
    src/ngl.c
    src/nim.c
    src/noise.c
    src/nosc.c
    src/nrf.c
    src/nul.c
    src/nvr.cpp
    src/nwm.c
    src/obj.c
    src/vec.c)

add_executable(frequensea ${SOURCE_FILES})
target_link_libraries(frequensea ${CORE_LIBS} ${PLATFORM_LIBS} stdc++ lua)
