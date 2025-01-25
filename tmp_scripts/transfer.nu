#!/usr/bin/env nu

def main [
	old_pwd: string
	new_pwd: string
] {
	open "processed.json"
	| each { |snapshot| 
		let tmp = mktemp --directory --tmpdir
		
		let $dir = (if ($snapshot.paths.0 | str contains "minecraft_server") { $"($tmp)/minecraft_server/." } else { $"($tmp)/." }) | inspect
		let $label = (if "dedede_v2" in $snapshot.tags { "Minecraft Server DEDEDE REBORN" } else { "Minecraft Server DEDEDE" }) | inspect
		let $time = $snapshot.time | inspect
		let $tags = $snapshot.tags | str join "," | inspect

		RUSTIC_PASSWORD=$old_pwd rustic -r /backup/old/restic_repo restore $snapshot.id $tmp --no-ownership

		RUSTIC_PASSWORD=$new_pwd rustic -r /stuff/Restic/repo backup $dir --time $time --tag $tags --label $label --as-path mc_server

		rm --recursive $tmp
		
		# exit
	}
}
