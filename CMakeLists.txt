project (systemsession)
cmake_minimum_required (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/systemsession")
set (RELEASE_NAME "summit")
set (VERSION "0.1")
set (VERSION_INFO "Stable")
set (ARCHIVE_NAME systemsession-${VERSION})


find_package(PkgConfig)
add_definitions(${DEPS_CFLAGS})


link_directories(${DEPS_LIBRARY_DIRS})
find_package(Vala REQUIRED)
include(ValaVersion)
include(ValaPrecompile)

pkg_check_modules(DEPS REQUIRED acis)
find_package(Vala REQUIRED)

ensure_vala_version("0.16" MINIMUM)
vala_precompile(VALA_C
    src/Main.vala
    src/Control/Control.vala
    src/Services/ProcessWrapper.vala
PACKAGES
    acis
    gee-0.8
    gio-2.0
OPTIONS
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
   --disable-warnings
    )

add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code -Wstrict-prototypes)
add_executable(systemsession ${VALA_C})
target_link_libraries(systemsession ${DEPS_LIBRARIES})
install(TARGETS systemsession RUNTIME DESTINATION /System/Applications/)
install(FILES data/systemsession.desktop DESTINATION /usr/share/applications/)
install(FILES data/kedos.session DESTINATION /usr/share/gnome-session/sessions/)
install(FILES data/kedos.desktop DESTINATION /usr/share/xsessions/)
