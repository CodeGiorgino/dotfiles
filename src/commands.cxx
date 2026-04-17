#include "commands.hxx"

#include <filesystem>
#include <iostream>
#include <print>

#include "parser.hxx"

namespace fs = std::filesystem;

namespace commands {
    auto update(const enviroment& env) -> void {
        const std::string repoFilesPath { fs::current_path() / "files" };
        if (!fs::exists(repoFilesPath))
            if (!fs::create_directory(repoFilesPath))
                throw std::runtime_error(
                        std::format(
                            "Error: cannot create repository files directory: "
                            "[{}]", repoFilesPath));

        parser p { env.sourcePath };
        for (const auto& filePath : p.lines()) {
            const std::string parentPath { fs::path { filePath }.parent_path() };
            const std::string filename { fs::path { filePath }.filename() };

            const std::string hash {
                std::format("{:0>20}", std::hash<std::string> {}(filePath))
            };

            const std::string repoFilePath {
                fs::path { repoFilesPath } / hash
            };

            if (env.target == "local") {
                if (!fs::exists(repoFilePath)) {
                    std::println(std::cerr,
                            "Error: cannot find repository file: [{:20}] [{}]",
                            filename, repoFilePath);
                    continue;
                }

                if (!fs::exists(parentPath)
                        && !fs::create_directories(parentPath)) {
                    std::println(std::cerr,
                            "Error: cannot copy file to local path: [{:20}]\n"
                            "       cannot create parent path: [{}]", filename,
                            parentPath);
                    continue;
                }

                std::println(std::clog,
                        "Updating local file: [{:20}] [{}]", filename,
                        repoFilePath);
                fs::copy(repoFilePath, filePath,
                        fs::copy_options::overwrite_existing);
            } else if (env.target == "repo") {
                if (!fs::exists(filePath)) {
                    std::println(std::cerr,
                            "Error: cannot find local file: [{:20}] [{}]",
                            filename, parentPath);
                    continue;
                }

                std::println(std::clog,
                        "Updating repository file: [{:20}] [{}]", filename,
                        repoFilePath);
                fs::copy(filePath, repoFilePath,
                        fs::copy_options::overwrite_existing);
            } else throw std::runtime_error(
                    std::format(
                        "Error: cannot execute command: {:?}\n"
                        "       unknown target: {:?}", env.command, env.target));
        }
    }

    auto diff(const enviroment& env) -> void {
        std::println("{:22} {:22} status", "filename", "hash");

        const std::string repoFilesPath { fs::current_path() / "files" };

        parser p { env.sourcePath };
        for (const auto& filePath : p.lines()) {
            const std::string filename { fs::path { filePath }.filename() };

            const std::string hash {
                std::format("{:0>20}", std::hash<std::string> {}(filePath))
            };

            const std::string repoFilePath {
                fs::path { repoFilesPath } / hash
            };

            std::print("[{:20}] [{}] ", filename, hash);

            if (!fs::exists(repoFilePath)) {
                std::println("missing");
                continue;
            } else if (!fs::exists(filePath)) {
                std::println("missing local");
                continue;
            }

            // TODO: check file content
            throw std::runtime_error("Error: commands::diff not implemented yet");
        }
    }
} // namespace commands
