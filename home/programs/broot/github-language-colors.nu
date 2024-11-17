#!/usr/bin/env nu

const GITHUB_LINGUIST_LANGUAGES_DB_URL = "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"
const OUTPUT_FILE = "./github-language-colors.nix"


def extend []  { reduce {|it, acc| $it | merge $acc} }


http get $GITHUB_LINGUIST_LANGUAGES_DB_URL
| values
| where color? != null and extensions? != null
| each {|row|
	$row.extensions | str substring 1.. | each {|ext| {$ext: $row.color} } | extend
} 
| extend
| do {
	let input = $in
	let nix_kv_pairs = ($input | items {|k,v| $"\"($k)\" = \"($v)\";"} | str join "\n")

	"{" ++ $nix_kv_pairs ++ "}" | save --force $OUTPUT_FILE
}
