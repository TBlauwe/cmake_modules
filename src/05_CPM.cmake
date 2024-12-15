macro(tcm_setup_cpm)
    set(CPM_INDENT "   ")
    set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)  # See https://github.com/cpm-cmake/CPM.cmake?tab=readme-ov-file#cpm_use_named_cache_directories
    if(NOT DEFINED CPM_DOWNLOAD_VERSION)
        set(CPM_DOWNLOAD_VERSION 0.40.2)
        set(CPM_HASH_SUM "c8cdc32c03816538ce22781ed72964dc864b2a34a310d3b7104812a5ca2d835d")
    endif()

    if(CPM_SOURCE_CACHE)
        set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
    elseif(DEFINED ENV{CPM_SOURCE_CACHE})
        set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
    else()
        set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
    endif()

    # Expand relative path. This is important if the provided path contains a tilde (~)
    get_filename_component(CPM_DOWNLOAD_LOCATION ${CPM_DOWNLOAD_LOCATION} ABSOLUTE)

    function(download_cpm)
        tcm_info("Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
        file(DOWNLOAD https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
                ${CPM_DOWNLOAD_LOCATION}
                EXPECTED_HASH SHA256=${CPM_HASH_SUM}
        )
    endfunction()

    if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
        download_cpm()
    else()
        # resume download if it previously failed
        file(READ ${CPM_DOWNLOAD_LOCATION} check)
        if("${check}" STREQUAL "")
            download_cpm()
        endif()
    endif()

    include(${CPM_DOWNLOAD_LOCATION})
    tcm_log("Using CPM : ${CPM_DOWNLOAD_LOCATION}")
endmacro()
