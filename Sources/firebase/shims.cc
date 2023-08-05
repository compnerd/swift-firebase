
#include <firebase/auth.h>

#if defined(_WIN32)
namespace firebase {
namespace auth {
Auth::Auth(const Auth &) noexcept = default;
}
}
#endif
