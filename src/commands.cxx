#include "commands.hxx"
#include <print>

#include "parser.hxx"

namespace commands {
    auto update(const enviroment& env) -> void {
        parser p { env.sourcePath };
        for (const auto& line : p.lines())
            std::println("{:?}", line);

        // TODO: not implemented yet
        throw std::runtime_error("Error: commands::update not implemented yet");
    }

    auto diff(const enviroment& env) -> void {
        // TODO: not implemented yet
        throw std::runtime_error("Error: commands::diff not implemented yet");
    }
} // namespace commands
