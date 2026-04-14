#pragma once
#include <filesystem>
#include <generator>
#include <string>

class parser final {
    public:
        explicit parser(std::string_view filePath);

    public:
        auto lines(void) noexcept -> std::generator<std::string>;

    private:
        std::filesystem::path filePath {};
};
