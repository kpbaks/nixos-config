# alias.unstage=reset HEAD --
# commit.verbose=true
# credential.https://gist.github.com.helper=/nix/store/rvh57nqm6sg081pa84k5lcddn6zkvvnm-gh-2.60.0/bin/gh auth
# git-credential
# credential.https://github.com.helper=/nix/store/rvh57nqm6sg081pa84k5lcddn6zkvvnm-gh-2.60.0/bin/gh auth
# git-credential
# diff.external=/nix/store/l2mv2a9v5rw3z4j2x037h7k7640ghh7g-difftastic-0.61.0/bin/difft --color auto --background
# light --display side-by-side-show-both
# filter.lfs.clean=git-lfs clean -- %f
# filter.lfs.process=git-lfs filter-process
# filter.lfs.required=true
# filter.lfs.smudge=git-lfs smudge -- %f
# init.defaultbranch=main
# merge.conflictstyle=zdiff3
# merge.tool=nvimdiff
# pull.rebase=false
# push.autosetupremote=true
# rebase.autosquash=true
# rerere.enabled=true
# 

export def 'merge deep' [other: any]: any -> any {
  let self = $in
  def type [] { describe | split row < | get 0 }
  match [($self | type) ($other | type)] {
    [record record] => { merge record $self $other }
    [list list] => { $self ++ $other }
    [_ nothing] => $self
    _ => $other
  }
}

def 'merge record' [self: record other: record]: nothing -> record {
  let keys = ($self | columns) ++ ($other | columns) | uniq
  let table = $keys | par-each { |key|
    alias value = get --ignore-errors $key
    { key: $key val: ($self | value | merge deep ($other | value)) }
  }
  $table | transpose --header-row --as-record
}


# def unflatten []

git config --list
| lines
| split column --number 2 "="
| rename key value
| update value {
	let input = $in
	match $input {
		"true" => true,
		"false" => false,
		_ => {
			try {
				$input | into int
			} catch {
				$input
			}
		}
	}
}
| update key {|row|
	$row.key
	| split row "."
	| do {
		match $in {
			# handle the case where parts of the key contains dots
			# e.g. credential.https://github.com.helper=!/run/current-system/sw/bin/gh auth git-credential
			["credential", ..$tail] => ["credential", ($tail | str join "")],
			_ => $in
		}
	}
	| reverse
	| reduce --fold $row.value {|it, acc| {$it: $acc}}
}
| get key
| reduce {|it, acc| $it | merge deep $acc}
