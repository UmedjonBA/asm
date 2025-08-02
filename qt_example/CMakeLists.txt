cmake_minimum_required(VERSION 3.16)
project(SimpleGuiApp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets)

qt_standard_project_setup()

qt_add_executable(SimpleGuiApp main.cpp)

target_link_libraries(SimpleGuiApp Qt6::Core Qt6::Widgets)

# Статическая сборка
set_target_properties(SimpleGuiApp PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)