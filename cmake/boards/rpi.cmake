#--------------------------------------------------------------------
# This file was created as a part of the LinuxDrone project:
#                http://www.linuxdrone.org
#
# Distributed under the Creative Commons Attribution-ShareAlike 4.0
# International License (see accompanying License.txt file or a copy
# at http://creativecommons.org/licenses/by-sa/4.0/legalcode)
#
# The human-readable summary of (and not a substitute for) the
# license: http://creativecommons.org/licenses/by-sa/4.0/
#--------------------------------------------------------------------

# Include guard
if(__RPI_CMAKE)
    return()
endif()
set(__RPI_CMAKE 1)

#
# RPI, Debian Wheezy, gcc-linaro-arm-linux-gnueabihf-raspbian Debian EGLIBC 2.13-37+rpi1
#

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)

# Extra cmake modules path (must be here since this is the first file which
# is processed by cmake, but it also uses custom modules)
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/modules/" ${CMAKE_MODULE_PATH})

# Get downloads and tools directories (read the module source for details)
include(FindProjectDirectories)

# Set variable for path board directory
if(DEFINED ENV{LINUXDRONE_BOARD_DIR})
    file(TO_CMAKE_PATH "$ENV{LINUXDRONE_ROOTFS_DIR}" BRD_DIR)
    message(STATUS "User-defined board Raspberry PI directory: ${BRD_DIR}")
else()
    set(BRD_DIR ${TOOLS_DIR}/board/rpi)
    message(STATUS "Automatically set board Raspberry PI directory: ${BRD_DIR}")
endif()
# Set variable for path board rootfs directory
if(DEFINED ENV{LINUXDRONE_ROOTFS_DIR})
    file(TO_CMAKE_PATH "$ENV{LINUXDRONE_ROOTFS_DIR}" RFS_DIR)
    message(STATUS "User-defined rootfs Raspberry PI directory: ${RFS_DIR}")
else()
    set(RFS_DIR ${BRD_DIR}/rootfs)
    message(STATUS "Automatically set rootfs Raspberry PI directory: ${RFS_DIR}")
endif()

if(CROSS_COMPILED_USE)
	# Define the cross compiler details (as extracted from distribution)
	if(CMAKE_HOST_WIN32)
                set(TOOLCHAIN_SUBDIR "cc")
		set(CMAKE_HOST_EXECUTABLE_SUFFIX ".exe")
	elseif(CMAKE_HOST_APPLE)
                set(TOOLCHAIN_SUBDIR "cc")
		set(CMAKE_HOST_EXECUTABLE_SUFFIX "")
	else()
                set(TOOLCHAIN_SUBDIR "cc")
		set(CMAKE_HOST_EXECUTABLE_SUFFIX "")
	endif()
	set(CROSS_TOOLCHAIN_PREFIX arm-linux-gnueabihf-)

	# Define compilers
	set(TOOLCHAIN_PREFIX   ${BRD_DIR}/${TOOLCHAIN_SUBDIR}/bin/${CROSS_TOOLCHAIN_PREFIX})
	set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc${CMAKE_HOST_EXECUTABLE_SUFFIX})
	set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++${CMAKE_HOST_EXECUTABLE_SUFFIX})
else()
	# Define compilers
	set(CMAKE_C_COMPILER   gcc)
	set(CMAKE_CXX_COMPILER g++)
endif()

#add_definitions(-std=c++11)

# Where is the target environment
set(CMAKE_FIND_ROOT_PATH ${RFS_DIR})

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
