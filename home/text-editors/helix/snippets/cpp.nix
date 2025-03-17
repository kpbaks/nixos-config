# TODO: convert
# [[snippets]]
# body = """
# auto main(int argc, char **argv) -> int {
#     $1

#     return 0;
# }"""
# prefix = "main"
# scope = ["cpp"]

# [[snippets]]
# body = "const "
# prefix = "c"
# scope = ["cpp"]

# [[snippets]]
# body = "const auto "
# prefix = "ca"
# scope = ["cpp"]

# [[snippets]]
# body = "constexpr "
# prefix = "ce"
# scope = ["cpp"]

# [[snippets]]
# body = "constexpr auto "
# prefix = "cea"
# scope = ["cpp"]

# [[snippets]]
# body = "consteval "
# prefix = "cev"
# scope = ["cpp"]

# [[snippets]]
# body = '''std::cout << "$1" << '\n';'''
# prefix = "p"
# scope = ["cpp"]

# [[snippets]]
# body = '''std::cerr << "$1" << '\n';'''
# prefix = "pe"
# scope = ["cpp"]

# [[snippets]]
# body = '''std::cerr << __FILE__ << ':' << __LINE__ << " $1 = " << $1 << '\n';'''
# prefix = "pv"
# scope = ["cpp"]

# [[snippets]]
# body = "std::optional<$1>"
# prefix = "opt"
# scope = ["cpp"]

# [[snippets]]
# body = "std::expected<$1,>"
# prefix = "expected"
# scope = ["cpp"]

# [[snippets]]
# body = "std::unique_ptr<$1>"
# prefix = "box"
# scope = ["cpp"]

# [[snippets]]
# body = "std::shared_ptr<$1>"
# prefix = "rc"
# scope = ["cpp"]

# [[snippets]]
# body = "std::vector<$1>"
# prefix = "vec"
# scope = ["cpp"]

# [[snippets]]
# body = "std::array<$1, 5>"
# prefix = "array"
# scope = ["cpp"]

# [[snippets]]
# body = "std::unordered_map<$1, >"
# prefix = "hmap"
# scope = ["cpp"]

# [[snippets]]
# body = "[&] () { $1 }"
# prefix = "closure"
# scope = ["cpp"]

# [[snippets]]
# body = "[]($1) { return ; }"
# prefix = "lambda"
# scope = ["cpp"]

# [[snippets]]
# body = """
# [&] {
#             auto it = $1;
#             return it;
#           }();"""
# prefix = "use"
# scope = ["cpp"]

# [[snippets]]
# body = """
# #include <array>
# #include <deque>
# #include <forward_list>
# #include <list>
# #include <memory>
# #include <mutex>
# #include <thread>
# #include <vector>
# #include <filesystem>
# #include <numeric>
# #include <optional>
# #include <variant>
# #include <string_view>
# #include <format>
# #include <jthread>
# #include <span>
# #include <expected>
# #include <mdspan>
# #include <print>"""
# prefix = "prelude"
# scope = ["cpp"]

[ ]
