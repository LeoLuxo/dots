#!/usr/bin/env nu

def process [] {
	open snapshots.json
	| each { |nested| 
		let tags = $nested.0.tags
		$nested.1 | each { |snapshot| $snapshot | update tags { $tags } }
	}
	| flatten
	| to json
	| save processed.json --force
}

def main [
	old_pwd: string
	new_pwd: string
] {
	process

	open "processed.json"
	| each { |snapshot| 
		let $label = "Minecraft instances" | inspect
		let $path = "instances" | inspect
	
		let tmp = mktemp --directory --tmpdir
		
		let $dir =  $"($tmp)/." | inspect
		let $time = $snapshot.time | inspect
		let $tags = $snapshot.tags | str join "," | inspect

		RUSTIC_PASSWORD=$old_pwd rustic -r /backup/old/restic_repo restore $snapshot.id $tmp --no-ownership

		RUSTIC_PASSWORD=$new_pwd rustic -r /stuff/Restic/repo backup $dir --time $time --tag $tags --label $label --as-path $path

		rm --recursive $tmp
		
		# exit
	}
}
