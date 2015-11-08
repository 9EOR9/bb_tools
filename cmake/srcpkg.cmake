#
#  srcpkg.cmake
#
#  locates source package and extraccts it $ENV{test_dir}/pkg
#
IF(WIN32)
  SET(PACKAGE_SUFFIX ".zip")
  SET(EXTRACT_COMMAND "unzip")
  SET(EXTRACT_OPTION "-d")
ELSE()
  SET(PACKAGE_SUFFIX ".tar.gz")
  SET(EXTRACT_COMMAND tar -xzf)
  SET(EXTRACT_OPTION -C)
ENDIF()

# 
# cmake -P doesn't support additional parameters, so
# directory needs to be defined by environment variable
#
IF("$ENV{PKG_TEST_DIIR}" STREQUAL "")
  SET(PKG_TEST_DIIR "../test")
ELSE()
  SET(PKG_TEST_DIIR $ENV{PKG_TEST_DIIR})
ENDIF()

FILE(GLOB PACKAGE_FILE "*-src${PACKAGE_SUFFIX}")

IF(NOT EXISTS ${PACKAGE_FILE})
  MESSAGE(FATAL_ERROR "Couldn't find source package")
ENDIF()

MESSAGE(STATUS "Package ${PACKAGE_FILE} will be installed in ${PKG_TEST_DIIR}/pkg")

EXECUTE_PROCESS(COMMAND rm ${PKG_TEST_DIIR} -rf)
EXECUTE_PROCESS(COMMAND mkdir ${PKG_TEST_DIIR})
EXECUTE_PROCESS(COMMAND ${EXTRACT_COMMAND} ${PACKAGE_FILE} ${EXTRACT_OPTION} ${PKG_TEST_DIIR})

# since buildbot doesn't know the name of the directory, we rename it to pkg
FILE(GLOB PACKAGE_DIR "${PKG_TEST_DIIR}/*")
EXECUTE_PROCESS(COMMAND mv ${PACKAGE_DIR} ${PKG_TEST_DIIR}/pkg)
