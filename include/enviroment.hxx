#pragma once
#include <string>

struct enviroment final {
    [[maybe_unused]] std::string program {};
    std::string origin {};
    std::string sourcePath { "files.conf" };
};
