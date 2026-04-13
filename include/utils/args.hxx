#pragma once
#include <string>
#include <unordered_map>

namespace utils {
    class args final {
        public:
            explicit args(int argc, char** argv);

        public:
            auto get_option(std::string_view name) const noexcept
                -> std::string;

        private:
            std::string _program {};
            std::unordered_map<std::string, std::string> _options {};
    };
} // namespace utils
