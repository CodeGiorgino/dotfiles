#include "parser.hxx"

#include <format>
#include <fstream>

namespace fs = std::filesystem;

parser::parser(std::string_view filePath) :
    filePath(fs::absolute(filePath)) {
        if (!fs::exists(filePath))
            throw std::runtime_error(
                    std::format("Error: cannot find file to parse: {:?}",
                        filePath));
        else if (!fs::is_regular_file(filePath))
            throw std::runtime_error(
                    std::format(
                        "Error: cannot parse file: {:?}\n"
                        "       not a regular file", filePath));
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
                std::format("Error: cannot open file to parse: {:?}",
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
        else co_yield line;
    };
}
