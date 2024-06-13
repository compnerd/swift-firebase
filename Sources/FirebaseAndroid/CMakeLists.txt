# SPDX-License-Identifier: BSD-3-Clause

add_library(FirebaseAndroidJNI SHARED
  jni.c)
target_include_directories(FirebaseAndroidJNI PUBLIC
  include)
target_link_libraries(FirebaseAndroidJNI PRIVATE
  log)

add_jar(SwiftFirebase
          Native.java
        INCLUDE_JARS
          $ENV{ANDROID_SDK_ROOT}/platforms/android-${CMAKE_ANDROID_API}/android.jar)
