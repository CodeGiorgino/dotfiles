#include "commands.hxx"

#include <filesystem>
#include <iostream>
#include <print>

#include "parser.hxx"

namespace fs = std::filesystem;

namespace commands {
    auto update(const enviroment& env) -> void {
        const auto repoFilesPath { fs::current_path() / "files" };
        if (!fs::exists(repoFilesPath))
            if (!fs::create_directory(repoFilesPath))
                throw std::runtime_error(
                        std::format(
                            "Error: cannot create repository files directory: "
                            "{:?}", repoFilesPath.string()));

        parser p { env.sourcePath };
        for (const auto& filePath : p.lines()) {
            const auto hash = std::to_string(
                    std::hash<std::string> {}(filePath));
            if (env.target == "local") {
                const auto repoFilePath { repoFilesPath / hash };
                if (!fs::exists(repoFilePath)) {
                    std::println(std::cerr,
                            "Error: cannot find file in repository: {:?}\n"
                            "       expected hashed file name: {:?}",
                            filePath, hash);
                    continue;
                }

                const auto parentPath { fs::path { filePath }.parent_path() };
                if (!fs::exists(parentPath)
                        && !fs::create_directories(parentPath)) {
                    std::println(std::cerr,
                            "Error: cannot copy file to local path: {:?}\n"
                            "       cannot create parent path", filePath);
                    continue;
                }

                fs::copy(repoFilePath, filePath,
                        fs::copy_options::overwrite_existing);
            }
        }
    }

    auto diff(const enviroment& env) -> void {
        // TODO: not implemented yet
        throw std::runtime_error("Error: commands::diff not implemented yet");
    }
} // namespace commands
