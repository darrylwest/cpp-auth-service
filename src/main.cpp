//
// dpw
//

#include <spdlog/spdlog.h>
#include <app/tiny.hpp>
#include <string>
#include <termio/termio.hpp>
#include <print>

constexpr std::string_view BANNER = R"(
 _______ __                _______ __               __                _______
|_     _|__|.-----.--.--. |     __|  |_.---.-.----.|  |_.-----.----. |   _   |.-----.-----.
  |   | |  ||     |  |  | |__     |   _|  _  |   _||   _|  -__|   _| |       ||  _  |  _  |
  |___| |__||__|__|___  | |_______|____|___._|__|  |____|_____|__|   |___|___||   __|   __|
                  |_____|                                                     |__|  |__|
)";

int main() {
    using namespace termio::termio;

    std::println("{}{}\n{}Version: {}{}", green(), BANNER, yellow(), app::tiny::VERSION, reset());
    constexpr auto lang = "c++";
    spdlog::info("Hello and welcome to {} tiny application, version: {}", lang, app::tiny::VERSION);

    return 0;
}

