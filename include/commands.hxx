#pragma once

#include "enviroment.hxx"

namespace commands {
    auto update(const enviroment& env) -> void;
    auto diff(const enviroment& env) -> void;
} // namespace commands
