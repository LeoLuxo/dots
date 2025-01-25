#!/usr/bin/env nu

open snapshots.json
| each { |nested| 
	let tags = $nested.0.tags
	$nested.1 | each { |snapshot| $snapshot | update tags { $tags } }
}
| flatten
| to json
| save processed.json --force