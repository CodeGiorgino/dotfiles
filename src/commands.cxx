#include "commands.hxx"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <print>

#include "parser.hxx"

namespace fs = std::filesystem;

namespace commands {
    auto update(const enviroment& env) -> void {
        const std::string repoFilesPath {
            fs::absolute(fs::current_path() / "files")
        };

        if (!fs::exists(repoFilesPath))
            if (!fs::create_directory(repoFilesPath))
                throw std::runtime_error(
                        std::format(
                            "command error: cannot create repository files directory: [{}]",
                            repoFilesPath));

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
                            "command error: cannot find repository file: [{}] [{}]",
                            hash, repoFilePath);
                    continue;
                }

                if (!fs::exists(parentPath)
                        && !fs::create_directories(parentPath)) {
                    std::println(std::cerr,
                            "command error: file [{}]: cannot create local path: [{}]",
                            filename, parentPath);
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
                            "command error: cannot find local file: [{}] [{}]"
                            filename, parentPath);
                    continue;
                }

                std::println(std::clog,
                        "Updating repository file: [{:20}] [{}]", hash,
                        repoFilePath);
                fs::copy(filePath, repoFilePath,
                        fs::copy_options::overwrite_existing);
            } else throw std::runtime_error(
                    std::format(
                        "command error: command {:?}: unknown target: {:?}",
                        env.command, env.target));
        }
    }

    auto diff(const enviroment& env) -> void {
        std::println("{:22} | {:22} | status", "filename", "hash");

        const std::string repoFilesPath {
            fs::absolute(fs::current_path() / "files")
        };

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

            std::print("[{:20}] | [{}] | ", filename, hash);

            if (!fs::exists(repoFilePath)) {
                std::println("A");
                continue;
            } else if (!fs::exists(filePath)) {
                std::println("D");
                continue;
            }

            std::ifstream localStream { filePath };
            if (!localStream) {
                std::println(
                        "command error: cannot open local file: [{}] [{}]",
                        filename, parentPath);
                continue;
            }

            std::ifstream repoStream { repoFilePath };
            if (!repoStream) {
                std::println("command error: cannot open repository file: [{}] [{}]",
                        hash, repoFilePath);
                continue;
            }

            // size mismatch
            if (localStream.tellg() != repoStream.tellg()) {
                std::println("M");
                continue;
            }

            localStream.seekg(0, std::ifstream::beg);
            repoStream.seekg(0, std::ifstream::beg);
            if (std::equal(std::istreambuf_iterator<char>(localStream.rdbuf()),
                    std::istreambuf_iterator<char>(),
                    std::istreambuf_iterator<char>(repoStream.rdbuf())))
                std::println("OK");
            else std::println("M");
        }
    }
} // namespace commands
