/* SPDX-License-Identifier: BSD-3-Clause */

#ifndef SwiftFirebase_FirebaseAndroidShim_logging_h
#define SwiftFirebase_FirebaseAndroidShim_logging_h

#include <android/log.h>

#define FIREBASE_ANDROID_LOG(level, tag, ...) __android_log_print(level, tag, __VA_ARGS__)
#define FIREBASE_ANDROID_TAG                  "company.thebrowser.firebase"

#define LOG_DEBUG(...)   FIREBASE_ANDROID_LOG(ANDROID_LOG_DEBUG, FIREBASE_ANDROID_TAG, __VA_ARGS__)
#define LOG_VERBOSE(...) FIREBASE_ANDROID_LOG(ANDROID_LOG_VERBOSE, FIREBASE_ANDROID_TAG, __VA_ARGS__)
#define LOG_INFO(...)    FIREBASE_ANDROID_LOG(ANDROID_LOG_INFO, FIREBASE_ANDROID_TAG, __VA_ARGS__)
#define LOG_WARN(...)    FIREBASE_ANDROID_LOG(ANDROID_LOG_WARN, FIREBASE_ANDROID_TAG, __VA_ARGS__)
#define LOG_ERROR(...)   FIREBASE_ANDROID_LOG(ANDROID_LOG_ERROR, FIREBASE_ANDROID_TAG, __VA_ARGS__)

#endif
