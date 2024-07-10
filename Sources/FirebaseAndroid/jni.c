/* SPDX-License-Identifier: BSD-3-Clause */

#include "FirebaseAndroid.h"
#include "abi.h"
#include "log.h"

#include <assert.h>

static JavaVM *g_VM;
static JNIEnv *g_Env;
static jobject *g_Activity;

#define N_ELEMENTS(array) (sizeof((array)) / sizeof(*(array)))

static const char kClassPath[] = "company/thebrowser/Native";

static jboolean
SwiftFirebase_RegisterActivity(JNIEnv *env, jobject *this, jobject *activity)
{
  assert(g_Activity == NULL && "re-registeration of activity");
  if (g_Activity) return JNI_FALSE;

  g_Activity = activity;
  return JNI_TRUE;
}

static JNINativeMethod kMethods[] = {
  { "RegisterActivity", "()Z", SwiftFirebase_RegisterActivity },
};

static void
RegisterNativeMethods(JNIEnv *env)
{
  jclass class;
  jint result;

  class = (*env)->FindClass(env, kClassPath);
  if (class == NULL) {
    LOG_ERROR("unable to find class '%s'", kClassPath);
    return;
  }
  LOG_DEBUG("located class path '%s': %p", kClassPath, class);

  result = (*env)->RegisterNatives(env, class, kMethods, N_ELEMENTS(kMethods));
  if (result < 0) {
    LOG_ERROR("JVM.RegisterNatives(%s): %u", kClassPath, result);
    return;
  }
  LOG_DEBUG("registered %lu methods", N_ELEMENTS(kMethods));
}

FIREBASE_ANDROID_ABI
jint JNI_OnLoad(JavaVM *vm, void *reserved)
{
  g_VM = vm;
  if ((*g_VM)->GetEnv(g_VM, (void **)&g_Env, JNI_VERSION_1_6) != JNI_OK)
    return -1;
  RegisterNativeMethods(g_Env);
  return JNI_VERSION_1_6;
}

FIREBASE_ANDROID_ABI
jobject SwiftFirebase_GetActivity(void)
{
  assert(g_Activity && "`GetActivity` invoked before `RegisterActivity`");
  return *g_Activity;
}

FIREBASE_ANDROID_ABI
JNIEnv *SwiftFirebase_GetJavaEnvironment(void)
{
  return g_Env;
}

FIREBASE_ANDROID_ABI
JavaVM *SwiftFirebase_GetJVM(void)
{
  return g_VM;
}
