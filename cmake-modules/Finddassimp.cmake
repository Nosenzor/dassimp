if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(ASSIMP_ARCHITECTURE "64")
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
	set(ASSIMP_ARCHITECTURE "32")
endif(CMAKE_SIZEOF_VOID_P EQUAL 8)
	
if(WIN32)
	set(ASSIMP_ROOT_DIR CACHE PATH "ASSIMP root directory")

	# Find path of each library
	find_path(DASSIMP_INCLUDE_DIR
		NAMES
			dassimp/anim.h
		HINTS
			${ASSIMP_ROOT_DIR}/include
	)

	if(MSVC12)
		set(ASSIMP_MSVC_VERSION "vc120")
	elseif(MSVC14)	
		set(ASSIMP_MSVC_VERSION "vc140")
	endif(MSVC12)
	
	if(MSVC12 OR MSVC14)
	
		find_path(DASSIMP_LIBRARY_DIR
			NAMES
				dassimp-${ASSIMP_MSVC_VERSION}-mt.lib
			HINTS
				${ASSIMP_ROOT_DIR}/lib${ASSIMP_ARCHITECTURE}
		)
		
		find_library(DASSIMP_LIBRARY_RELEASE				dassimp-${ASSIMP_MSVC_VERSION}-mt.lib 			PATHS ${ASSIMP_LIBRARY_DIR})
		find_library(DASSIMP_LIBRARY_DEBUG				dassimp-${ASSIMP_MSVC_VERSION}-mtd.lib			PATHS ${ASSIMP_LIBRARY_DIR})
		
		set(DASSIMP_LIBRARY
			optimized 	${ASSIMP_LIBRARY_RELEASE}
			debug		${ASSIMP_LIBRARY_DEBUG}
		)
		
		set(DASSIMP_LIBRARIES "DASSIMP_LIBRARY_RELEASE" "DASSIMP_LIBRARY_DEBUG")
	
		FUNCTION(ASSIMP_COPY_BINARIES TargetDirectory)
			ADD_CUSTOM_TARGET(AssimpCopyBinaries
				COMMAND ${CMAKE_COMMAND} -E copy ${ASSIMP_ROOT_DIR}/bin${ASSIMP_ARCHITECTURE}/dassimp-${ASSIMP_MSVC_VERSION}-mtd.dll 	${TargetDirectory}/Debug/dassimp-${ASSIMP_MSVC_VERSION}-mtd.dll
				COMMAND ${CMAKE_COMMAND} -E copy ${ASSIMP_ROOT_DIR}/bin${ASSIMP_ARCHITECTURE}/dassimp-${ASSIMP_MSVC_VERSION}-mt.dll 		${TargetDirectory}/Release/dassimp-${ASSIMP_MSVC_VERSION}-mt.dll
			COMMENT "Copying Assimp binaries to '${TargetDirectory}'"
			VERBATIM)
		ENDFUNCTION(ASSIMP_COPY_BINARIES)
	
	endif()
	
else(WIN32)

	find_path(
	  dassimp_INCLUDE_DIRS
	  NAMES dassimp/postprocess.h dassimp/scene.h dassimp/version.h dassimp/config.h dassimp/cimport.h
	  PATHS /usr/local/include
	  PATHS /usr/include/

	)

	find_library(
	  dassimp_LIBRARIES
	  NAMES dassimp
	  PATHS /usr/local/lib/
	  PATHS /usr/lib64/
	  PATHS /usr/lib/
	)

	if (dassimp_INCLUDE_DIRS AND dassimp_LIBRARIES)
	  SET(dassimp_FOUND TRUE)
	ENDIF (dassimp_INCLUDE_DIRS AND assimp_LIBRARIES)

	if (dassimp_FOUND)
	  if (NOT dassimp_FIND_QUIETLY)
		message(STATUS "Found asset importer library: ${dassimp_LIBRARIES}")
	  endif (NOT assimp_FIND_QUIETLY)
	else (dassimp_FOUND)
	  if (dassimp_FIND_REQUIRED)
		message(FATAL_ERROR "Could not find asset importer library")
	  endif (dassimp_FIND_REQUIRED)
	endif (dassimp_FOUND)
	
endif(WIN32)
