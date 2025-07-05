//
// dpw
//

#include <spdlog/spdlog.h>
#include <app/auth.hpp>
#include <termio/termio.hpp>
#include <print>

int main() {
    using namespace termio::termio;
    using namespace app;

    std::println("{}{}\n{}Version: {}{}", green(), auth::BANNER, yellow(), auth::VERSION, reset());

    spdlog::info("Hello and welcome to auth service, version: {}", auth::VERSION);

    return 0;
}

