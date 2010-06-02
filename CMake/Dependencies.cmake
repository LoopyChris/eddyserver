set(EDDY_DEPENDENCIES_DIR "" CACHE PATH "Path to prebuilt EDDY dependencies")
include(FindPkgMacros)
include(MacroLogFeature)
getenv_path(EDDY_DEPENDENCIES_DIR)

  set(EDDY_DEP_SEARCH_PATH 
    ${EDDY_DEPENDENCIES_DIR}
    ${ENV_EDDY_DEPENDENCIES_DIR}
    "${EDDY_BINARY_DIR}/dependencies"
    "${EDDY_SOURCE_DIR}/dependencies"
    "${EDDY_BINARY_DIR}/../dependencies"
    "${EDDY_SOURCE_DIR}/../dependencies"
  )


message(STATUS "Search path: ${EDDY_DEP_SEARCH_PATH}")

# Set hardcoded path guesses for various platforms
if (UNIX)
  set(EDDY_DEP_SEARCH_PATH ${EDDY_DEP_SEARCH_PATH} /usr/local)
endif ()

# give guesses as hints to the find_package calls
set(CMAKE_PREFIX_PATH ${EDDY_DEP_SEARCH_PATH} ${CMAKE_PREFIX_PATH})
set(CMAKE_FRAMEWORK_PATH ${EDDY_DEP_SEARCH_PATH} ${CMAKE_FRAMEWORK_PATH})

#######################################################################
# Core dependencies
#######################################################################
set(Boost_USE_STATIC_LIBS TRUE)
set(Boost_ADDITIONAL_VERSIONS "1.42" "1.42.0" "1.43" "1.43.0")

if (UNIX)
# Components that need linking (NB does not include header-only components like bind)
set(EDDY_BOOST_COMPONENTS thread date_time system)
find_package(Boost COMPONENTS ${EDDY_BOOST_COMPONENTS} QUIET)
if (NOT Boost_FOUND)
	# Try again with the other type of libs
	set(Boost_USE_STATIC_LIBS NOT ${Boost_USE_STATIC_LIBS})
	find_package(Boost COMPONENTS ${EDDY_BOOST_COMPONENTS} QUIET)
endif()
macro_log_feature(Boost_THREAD_FOUND "boost-thread" "Used for threading support" "http://boost.org" FALSE "" "")
macro_log_feature(Boost_DATE_TIME_FOUND "boost-date_time" "Used for threading support" "http://boost.org" FALSE "" "")
endif (UNIX)

find_package(Boost)
macro_log_feature(Boost_FOUND "boost" "Boost (general)" "http://boost.org" FALSE "" "")

find_package(Protobuf REQUIRED)
  
# Display results, terminate if anything required is missing
MACRO_DISPLAY_FEATURE_LOG()

# Add library and include paths from the dependencies
include_directories(
  ${Protobuf_INCLUDE_DIRS}
)

link_directories(
  ${Protobuf_LIBRARY_DIRS}
)

if (Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
  link_directories(${Boost_LIBRARY_DIRS})
endif ()
