cmake_minimum_required(VERSION 3.17)
project(CNChess)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if (DEFINED CMAKE_BUILD_TYPE)
    message(STATUS "CMAKE_BUILD_TYPE is defined: ${CMAKE_BUILD_TYPE}")
else ()
    message(STATUS "CMAKE_BUILD_TYPE is not defined")
    set(CMAKE_BUILD_TYPE Release)
endif ()

set(OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}")
# build output
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR})
set(EXECUTABLE_OUTPUT_PATH ${OUTPUT_DIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_DIR})
#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_DIR})

if ("$ENV{PATH}" MATCHES "Qt")
    message("System PATH contains 'Qt'")
    message(STATUS "ENV_PATH:  $ENV{PATH}")
else ()
    message("System PATH does not contain 'Qt' (CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME})")
    # QtMSVC path, check "build toolchain arch" first
    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        if (CMAKE_CL_64)
            list(APPEND CMAKE_PREFIX_PATH "C:\\Qt\\Qt6\\6.5.2\\msvc2019_64")
            message("build toolchain arch is 64 on windows")
        else ()
            message("build toolchain arch is 32 on windows")
        endif ()
    elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        #        list(APPEND CMAKE_PREFIX_PATH "/opt/homebrew/Cellar/qt/6.5.1_3/lib/cmake")
        list(APPEND CMAKE_PREFIX_PATH "/Users/wuxw/Qt/Qt6/6.5.3/macos")
        message("build toolchain on macOS/Darwin")
    else ()
        # 其他操作系统
        # 在这里添加针对其他操作系统的处理
    endif ()

    if (NOT CMAKE_PREFIX_PATH)
        message(WARNING "CMAKE_PREFIX_PATH is not defined, you may need to set it "
                "(-DCMAKE_PREFIX_PATH=\"path/to/Qt/lib/cmake\" or -DCMAKE_PREFIX_PATH=/usr/include/{host}/qt{version}/ on Ubuntu)")
    endif ()
endif ()

# user project define info:
set(REQUIRED_LIBS Core Gui Widgets Sql Network Multimedia)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS ${REQUIRED_LIBS})
message(STATUS "QT_VERSION_MAJOR: ${QT_VERSION_MAJOR}")
if (Qt${QT_VERSION_MAJOR}_FOUND)
    FOREACH(item ${REQUIRED_LIBS})
        list(APPEND REQUIRED_LIBS_QUALIFIED  "Qt${QT_VERSION_MAJOR}::${item}")
    ENDFOREACH()
    message("REQUIRED_LIBS_QUALIFIED: ${REQUIRED_LIBS_QUALIFIED}")
endif ()
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS ${REQUIRED_LIBS})

include_directories(
        code/uic
        code
)
# ui_xxx.h path
set(CMAKE_AUTOUIC_OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/code/uic)
# AutoUic *.ui files could not be found in omc_ui/src
list(APPEND CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/code)
# find_file(UI_FILES ui_xxx.h PATHS ${CMAKE_CURRENT_SOURCE_DIR}/omc_ui/uic NO_DEFAULT_PATH)

file(GLOB CODE_SRC code/*.h code/*.cpp)
#file(GLOB UTIL_SRC om/util/*.h om/util/*.cpp)

qt6_add_resources(QRCS app.qrc)

set(PROJECT_SOURCES
        ${CODE_SRC}
        ${QRCS}
        res.rc
)

qt6_add_resources(QRCS app.qrc)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME}
            MANUAL_FINALIZATION
            ${PROJECT_SOURCES}
            )
else()
    add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
endif()

if (Qt${QT_VERSION_MAJOR}_FOUND)
    target_link_libraries(${PROJECT_NAME} PRIVATE ${REQUIRED_LIBS_QUALIFIED})
else ()
    message(STATUS "Qt${QT_VERSION_MAJOR} NOT FOUND !!!")
endif ()

message("CMAKE_COMMAND: ${CMAKE_COMMAND}")


# POST_BUILD COMMAND:
# find windeployqt / macdeployqt execfile
find_program(DEPLOYQT_TOOL NAMES windeployqt macdeployqt HINTS "${QT_BIN_PATH}")
message(STATUS "DEPLOYQT_TOOL: ${DEPLOYQT_TOOL}")

#string(TOLOWER "${CMAKE_BUILD_TYPE}" BUILD_TYPE_LOWER)
## invok windeployqt
#add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD COMMAND
#        ${DEPLOYQT_TOOL} "$<TARGET_FILE:${PROJECT_NAME}>" $<$<CONFIG:${CMAKE_BUILD_TYPE}>:--${BUILD_TYPE_LOWER}> --qmldir ${CMAKE_SOURCE_DIR})
