#include <iostream>
#include <print>

#define VERSION    "1.0.0"
#define ANSI_BOLD  "\033[1m"
#define ANSI_RESET "\033[0m"

auto show_version(void) noexcept -> void {
    std::println("dottracker version {}", VERSION);
}

auto show_help(void) noexcept -> void {
    std::println(
ANSI_BOLD
"NAME                                                                          \n"
ANSI_RESET
"    dottracker - dotfiles tracker                                             \n"
"                                                                              \n"
ANSI_BOLD
"SYNOPSIS                                                                      \n"
ANSI_RESET
"    dottracker [-v | --version] [-h | --help] <command> [<args>]              \n"
"                                                                              \n"
ANSI_BOLD
"DESCRIPTION                                                                   \n"
ANSI_RESET
"    dottracker is a tracking program for UNIX dotfiles and configurations.    \n"
"                                                                              \n"
ANSI_BOLD
"OPTIONS                                                                       \n"
ANSI_RESET
"    -v, --version                                                             \n"
"        Prints the program version and exit.                                  \n"
"                                                                              \n"
"    -h, --help                                                                \n"
"        Prints the program help message and exit.                             \n"
"                                                                              \n"
ANSI_BOLD
"COMMANDS                                                                      \n"
ANSI_RESET
"    update <origin> [<-s | --source> <file_path>]                             \n"
"        Update files in origin:                                               \n"
"            - local: repository files overwrites local files.                 \n"
"            - repo:  local files overwrites repository files.                 \n"
"                                                                              \n"
ANSI_BOLD
"        Options:                                                              \n"
ANSI_RESET
"            -s, --source <file_path>                                          \n"
"                If specified, use the file provided for the update, otherwise \n"
"                'files.txt' is used.                                        \n"
"                                                                              \n"
"    diff                                                                      \n"
"        Check for differences between local and repository files.             \n"
        );
}

struct {
    [[maybe_unused]] std::string program {};
    std::string sourcePath { "files.conf" };
} env;

auto parse_args(int argc, char** argv) -> void {
    int argn = 1;
    const auto arg_next = [&](void) -> std::string {
        if (argn < argc) {
            const std::string ret { *(argv + argn) };
            argn++;
            return ret;
        } else return {};
    };

    // parse options
    while (argn < argc) {
        const auto option = arg_next();
        if (option.empty())
            continue;
        else if (option == "-v"
                || option == "--version") {
            show_version();
            exit(0);
        } else if (option == "-h"
                || option == "--help") {
            show_help();
            exit(0);
        } else if (option[0] == '-') {
            throw std::invalid_argument(
                    std::format("Error: unknown option: {:?}", option));
        } else {
            argn--;
            break;
        }
    };

    // parse command
    const std::string command = arg_next();
    if (command.empty())
        throw std::invalid_argument("Error: missing required command");
    else if (command == "update") {
        const auto origin = arg_next();
        if (origin.empty())
            throw std::invalid_argument(
                    std::format("Error: missing required value for command: "
                        "{:?}", command));

        // parse options
        for (; argn < argc; argn++) {
            const auto option = arg_next();
            if (option.empty())
                continue;
            else if (option == "-s"
                    || option == "--source") {
                const auto value = arg_next();
                if (value.empty())
                    throw std::invalid_argument(
                            std::format(
                                "Error: command: {:?}\n"
                                "       missing required value for option: "
                                "{:?}", command, option));
                env.sourcePath = value;
            } else throw std::invalid_argument(
                    std::format(
                        "Error: command: {:?}\n"
                        "       unknown option: {:?}", command, option));
        }
    } else if (command == "diff") {
        // TODO: not implemented yet
        throw std::invalid_argument(
                std::format("Error: command not implemented yet: {:?}",
                    command));
    } else throw std::invalid_argument(
            std::format("Error: unknown command: {:?}", command));
}

auto main(int argc, char** argv) -> int {
    env.program = *argv;

    if (argc == 1) {
        show_help();
        return 0;
    } else try {
        parse_args(argc, argv);
    } catch (const std::invalid_argument& ex) {
        const std::string err = ex.what();
        std::println(std::cerr, "{}\n"
                "Error: run 'dottracker --help' for all supported commands",
                err);
        return 1;
    } catch (const std::exception& ex) {
        const std::string err = ex.what();
        std::println(std::cerr, "{}", err);
        return 1;
    }


    return 0;
}
