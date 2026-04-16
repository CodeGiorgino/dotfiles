#pragma once
#include <string>

struct enviroment final {
    [[maybe_unused]] std::string program {};
    std::string target {};
    std::string sourcePath { "files.conf" };
};
