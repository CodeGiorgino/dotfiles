#include "commands.hxx"

#include <filesystem>
#include <print>
#include <ranges>

#include "parser.hxx"

namespace fs = std::filesystem;
namespace ranges = std::ranges;
namespace views = std::ranges::views;

namespace commands {
    auto update(const enviroment& env) -> void {
        parser p { env.sourcePath };
        for (const auto& line : p.lines()) {
            fs::path filePath {};
            for (const auto part : views::split(line, '/')) {
                const std::string partStr { std::string_view { part } };
                if (part.empty())
                    continue;
                else if (part[0] == '$') {
                    const auto realPart = std::getenv(
                            partStr.substr(1).c_str());
                    if (!realPart)
                        throw std::runtime_error(
                                std::format(
                                    "Error: cannot evaluate path: {:?}\n"
                                    "       cannot find env variable: {:?}",
                                    line, partStr));
                    else filePath /= std::string { realPart };
                } else filePath /= partStr;
            }

            std::println("filePath: {:?}", filePath.string());
        }

        // TODO: not implemented yet
        throw std::runtime_error("Error: commands::update not implemented yet");
    }

    auto diff(const enviroment& env) -> void {
        // TODO: not implemented yet
        throw std::runtime_error("Error: commands::diff not implemented yet");
    }
} // namespace commands
