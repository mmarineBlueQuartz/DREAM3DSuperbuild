#cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DQt5_DIR=/Users/Shared/DREAM3D_SDK/Qt5.9.2/5.9.2/clang_64/lib/cmake/Qt5 -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 -DModule_vtkGUISupportQtOpenGL=ON -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON -DVTK_USE_SYSTEM_HDF5=ON -DHDF5_C_INCLUDE_DIR=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Release/include -DHDF5_hdf5_LIBRARY_RELEASE=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Release/lib/libhdf5.dylib -DHDF5_hdf5_hl_LIBRARY_RELEASE=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Release/lib/libhdf5_hl.dylib  ../VTK-8.0.1



#cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DQt5_DIR=/Users/Shared/DREAM3D_SDK/Qt5.9.2/5.9.2/clang_64/lib/cmake/Qt5 -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 -DModule_vtkGUISupportQtOpenGL=ON -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON -DVTK_USE_SYSTEM_HDF5=ON -DHDF5_C_INCLUDE_DIR=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Debug/include -DHDF5_hdf5_LIBRARY_DEBUG=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Debug/lib/libhdf5_debug.dylib -DHDF5_hdf5_hl_LIBRARY_DEBUG=/Users/Shared/DREAM3D_SDK/hdf5-1.8.19-Debug/lib/libhdf5_hl_debug.dylib  ../VTK-8.0.1

set(extProjectName "VTK")
message(STATUS "External Project: ${extProjectName}" )

set(VTK_VERSION "8.1.1")
set(VTK_URL "https://gitlab.kitware.com/vtk/vtk/-/archive/v${VTK_VERSION}/vtk-v${VTK_VERSION}.tar.gz")
#set(VTK_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/VTK/InsightToolkit-${VTK_VERSION}.tar.gz")

set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}")
set(VTK_INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/${extProjectName}-${VTK_VERSION}-${CMAKE_BUILD_TYPE}")
set(BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build-${CMAKE_BUILD_TYPE}")

set(Qt5Dir)
set(Qt5CoreDir)
set(Qt5GuiDir)
set(Qt5SqlDir)
set(Qt5UiPluginDir)
set(Qt5WidgetsDir)

if(WIN32)
  set(SOURCE_DIR "${DREAM3D_SDK}/${extProjectName}-src")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}")
  set(VTK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}")
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(Qt5Dir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5")
  set(Qt5CoreDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5Core")
  set(Qt5GuiDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5Gui")
  set(Qt5SqlDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5Sql")
  set(Qt5UiPluginDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5UiPlugin")
  set(Qt5WidgetsDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/msvc2017_64/lib/cmake/Qt5Widgets")
elseif(APPLE)
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(VTK_INSTALL_DIR_NO_BUILD_TYPE "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}-")
  set(VTK_INSTALL_DIR "${VTK_INSTALL_DIR_NO_BUILD_TYPE}${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  set(Qt5Dir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5")
  set(Qt5CoreDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5Core")
  set(Qt5GuiDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5Gui")
  set(Qt5SqlDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5Sql")
  set(Qt5UiPluginDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5UiPlugin")
  set(Qt5WidgetsDir "${DREAM3D_SDK}/Qt${qt_version_full}/${qt_version_full}/clang_64/lib/cmake/Qt5Widgets")
elseif("${BUILD_VTK}" STREQUAL "ON")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(VTK_INSTALL_DIR_NO_BUILD_TYPE "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}-")
  set(VTK_INSTALL_DIR "${VTK_INSTALL_DIR_NO_BUILD_TYPE}${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-std=c++11")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(upper "DEBUG")
else()
  set(upper "RELEASE")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )


set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME vtk-v${VTK_VERSION}.tar.gz
  URL ${VTK_URL}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${SOURCE_DIR}"
  #BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  BINARY_DIR "${BINARY_DIR}"
  INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Install"
  
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -DVTK_GROUP_Qt=ON
    -DVTK_QT_VERSION=5
    -DQt5DIR=${Qt5Dir}
    -DQt5Core_DIR=${Qt5CoreDir}
    -DQt5Gui_DIR=${Qt5GuiDir}
    -DQt5Sql_DIR=${Qt5SqlDir}
    -DQt5UiPlugin_DIR=${Qt5UiPluginDir}
    -DQt5Widgets_DIR=${Qt5WidgetsDir}
    #-DVTK_INSTALL_QT_PLUGIN_DIR=${CMAKE_INSTALL_PREFIX}/${VTK_INSTALL_QT_DIR}
		
  
  DEPENDS Qt5
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

file(APPEND ${DREAM3D_SDK_FILE} "
#--------------------------------------------------------------------------------------------------
# Set VTK_DIR")

if(WIN32)
  file(APPEND ${DREAM3D_SDK_FILE} "
set(VTK_DIR ${VTK_INSTALL_DIR} CACHE PATH \"\")
")
else()
  file(APPEND ${DREAM3D_SDK_FILE} "
if( CMAKE_BUILD_TYPE MATCHES Debug ) 
  set(VTK_DIR ${VTK_INSTALL_DIR_NO_BUILD_TYPE}Debug CACHE PATH \"\")
else()
  set(VTK_DIR ${VTK_INSTALL_DIR_NO_BUILD_TYPE}Release CACHE PATH \"\")
endif()
")
endif()
