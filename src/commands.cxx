#include "commands.hxx"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <print>

#include "parser.hxx"

namespace fs = std::filesystem;

auto get_repo_files_path(const enviroment& env) -> fs::path {
    return {
        fs::absolute(env.program).parent_path() / "files"
    };
}

auto get_config_file_path(const enviroment& env) -> fs::path {
    if (env.sourcePath.empty()) {
        const auto homePathStr { std::getenv("HOME") };
        if (!homePathStr)
            throw std::runtime_error(
                    "system error: cannot find home path: try set 'HOME' enviroment variable,\n"
                    "              or provide a source file with the '-s | --source' option.");

        return {
            fs::path { homePathStr } / ".config" / "dottracker" / "files.conf"
        };
    } else return env.sourcePath;
}

namespace commands {
    auto update(const enviroment& env) -> void {
        const auto repoFilesPath = get_repo_files_path(env);
        if (!fs::exists(repoFilesPath))
            throw std::runtime_error(
                    std::format(
                        "command error: command {:?}: cannot find repository files directory: [{}]",
                        env.command, repoFilesPath.string()));

        parser p { get_config_file_path(env).string() };
        for (const auto& filePath : p.lines()) {
            const std::string parentPath { fs::path { filePath }.parent_path() };
            const std::string filename { fs::path { filePath }.filename() };

            const std::string hash {
                std::format("{:0>20}", std::hash<std::string> {}(filePath))
            };

            const auto repoFilePath { repoFilesPath / hash };

            if (env.target == "local") {
                if (!fs::exists(repoFilePath)) {
                    std::println(std::cerr,
                            "command error: command {:?}: cannot find repository file: [{}] [{}]",
                            env.command, hash, repoFilePath.string());
                    continue;
                }

                if (!fs::exists(parentPath)
                        && !fs::create_directories(parentPath)) {
                    std::println(std::cerr,
                            "command error: command: {:?}: file [{}]: cannot create local path: [{}]",
                            env.command, filename, parentPath);
                    continue;
                }

                std::println(std::clog,
                        "Updating local file: [{:20}] [{}]", filename,
                        repoFilePath.string());
                fs::copy(repoFilePath, filePath,
                        fs::copy_options::overwrite_existing);
            } else if (env.target == "repo") {
                if (!fs::exists(filePath)) {
                    std::println(std::cerr,
                            "command error: command {:?}: cannot find local file: [{}] [{}]",
                            env.command, filename, parentPath);
                    continue;
                }

                std::println(std::clog,
                        "Updating repository file: [{:20}] [{}]", hash,
                        repoFilePath.string());
                fs::copy(filePath, repoFilePath,
                        fs::copy_options::overwrite_existing);
            } else throw std::runtime_error(
                    std::format(
                        "command error: command {:?}: unknown target: {:?}",
                        env.command, env.target));
        }
    }

    auto diff(const enviroment& env) -> void {
        const auto repoFilesPath = get_repo_files_path(env);
        if (!fs::exists(repoFilesPath))
            throw std::runtime_error(
                    std::format(
                        "command error: command {:?}: cannot find repository files directory: [{}]",
                        env.command, repoFilesPath.string()));

        parser p { get_config_file_path(env).string() };

        std::println("{:22} | {:22} | status", "filename", "hash");
        for (const auto& filePath : p.lines()) {
            const std::string parentPath { fs::path { filePath }.parent_path() };
            const std::string filename { fs::path { filePath }.filename() };

            const std::string hash {
                std::format("{:0>20}", std::hash<std::string> {}(filePath))
            };

            const auto repoFilePath { repoFilesPath / hash };

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
                        "command error: command {:?}: cannot open local file: [{}] [{}]",
                        env.command, filename, parentPath);
                continue;
            }

            std::ifstream repoStream { repoFilePath.string() };
            if (!repoStream) {
                std::println("command error: command {:?}: cannot open repository file: [{}] [{}]",
                        env.command, hash, repoFilePath.string());
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
