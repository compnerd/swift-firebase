/* SPDX-License-Identifier: BSD-3-Clause */

#ifndef SwiftFirebase_FirebaseAndroidShim_FirebaseAndroid_h
#define SwiftFirebase_FirebaseAndroidShim_FirebaseAndroid_h

#include <jni.h>

#if defined(__cplusplus)
extern "C" {
#endif

jobject SwiftFirebase_GetActivity(void);
JNIEnv *SwiftFirebase_GetJavaEnvironment(void);
JavaVM *SwiftFirebase_GetJVM(void);

#if defined(__cplusplus)
}
#endif

#endif
