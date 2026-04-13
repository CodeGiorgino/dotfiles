#include "utils/args.hxx"

#include <print>

namespace utils {
    args::args(int argc, char** argv) {
        _program = *argv;

        for (int i = 1; i < argc; i++) {
            const std::string name = *(argv + i);
            if (name.empty())
                continue;
            else if (name[0] == '-') {
                std::string value {};
                if (i != argc - 1) {
                    const std::string next = *(argv + i + 1);
                    if (!next.empty() && next[0] != '-')
                        value = next;
                }

                _options[name] = value;
            }
        }

        for (const auto& [k, v] : _options)
            std::println("[d]: key = {:?}, value = {:?}", k, v);
    }

    auto args::get_option(std::string_view name) const noexcept
        -> std::string {
            if (const auto it = _options.find(std::string { name });
                    it != _options.end())
                return it->second;
            else return {};
        }
} // namespace utils
