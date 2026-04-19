#include "parser.hxx"

#include <format>
#include <fstream>
#include <ranges>

namespace fs = std::filesystem;
namespace ranges = std::ranges;
namespace views = std::ranges::views;

parser::parser(std::string_view filePath) :
    filePath(fs::absolute(filePath)) {
        if (!fs::exists(filePath))
            throw std::runtime_error(
                    std::format("parser error: cannot find file: [{}]",
                        filePath));
        else if (!fs::is_regular_file(filePath))
            throw std::runtime_error(
                    std::format(
                        "parser error: file [{}]: not a regular file",
                        filePath));
    }

auto trim(std::string_view str) noexcept -> std::string_view {
    if (str.empty())
        return {};

    size_t start = 0;
    size_t end   = str.size() - 1;
    for (; start < end && std::isspace(str[start]); start++);
    for (; end > start && std::isspace(str[end]); end--);

    return str.substr(start, end - start + 1);
}

auto parser::lines(void) noexcept -> std::generator<std::string> {
    std::ifstream streamIn { filePath };
    if (!streamIn)
        throw std::runtime_error(
                std::format(
                    "parser error: cannot open file: [{}]",
                    filePath.string()));

    std::string line;
    while (std::getline(streamIn, line)) {
        if (line.empty())
            continue;

        line = trim(line);
        if (line.empty())
            continue;
        else if (line[0] == '#')
            continue;

        fs::path realFilePath {};
        if (line[0] == '/')
            realFilePath /= "/";

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
                                "parser error: line {:?}: cannot evaluate enviroment variable: {:?}",
                                line, partStr));
                else realFilePath /= std::string { realPart };
            } else realFilePath /= partStr;
        }

        co_yield realFilePath.string();
    };
}
