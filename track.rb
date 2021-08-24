require 'nokogiri'
require 'csv'

last_mtime = nil
path = "SaveGameInfo"
out = "out.csv"
maps = {}

[
	"yearForSaveGame", "seasonForSaveGame", "dayOfMonthForSaveGame", 
	"money", "totalMoneyEarned",
	"saveTime", "millisecondsPlayed", 
	"farmingLevel", "miningLevel", "combatLevel", "foragingLevel", "fishingLevel", "luckLevel",
	"health", "maxHealth", "stamina", "maxStamina", "maxItems",
	"attack", "immunity", "resilience",
	"qiGems", "daysMarried", "deepestMineLevel", "timesReachedMineBottom",
	"gameVersion",
].each do |v|
	maps[v] = "//Farmer/#{v}"
end

[
	"daysPlayed",
	"seedsSown", "itemsShipped", "itemsCooked", "itemsCrafted",
	"cropsShipped", "itemsForaged", "slimesKilled", "geodesCracked",
	"goodFriends", "totalMoneyGifted", "individualMoneyEarned",
	"stoneGathered", "rocksCrushed", "dirtHoed", "giftsGiven",
	"timesUnconscious", "averageBedtime", "timesFished", "fishCaught",
	"bouldersCracked", "stumpsChopped", "stepsTaken",
	"monstersKilled", "diamondsFound", "prismaticShardsFound", "otherPreciousGemsFound",
	"copperFound", "ironFound", "coalFound", "coinsFound", "goldFound", "iridiumFound", "barsSmelted",
	"beveragesMade", "preservesMade", "piecesOfTrashRecycled", "mysticStonesCrushed",
	"weedsEliminated", "sticksChopped", "notesFound", "questsCompleted", "starLevelCropsShipped",
].each do |v|
	maps["stats/#{v}"] = "//Farmer/stats/#{v}"
end

if !File.exist?(out)
	File.open(out, "a") do |fp|
		puts "Creating blank CSV #{out}..."
		csv = CSV.new(fp)
		csv << ["timestamp", "achievements", "songsHeard", "eventsSeen", "cookingRecipes", "craftingRecipes"] + maps.keys.map(&:to_s)
	end
end

while true
	if !last_mtime || File.mtime(path) > last_mtime
		puts "Loading #{path}..."

		input = File.read(path)
		xml = Nokogiri::XML(input)

		values = {
			"timestamp" => Time.now,
			"achievements" => xml.xpath("count(//Farmer/achievements/int)").to_i,
			"songsHeard" => xml.xpath("count(//Farmer/songsHeard/string)").to_i,
			"eventsSeen" => xml.xpath("count(//Farmer/eventsSeen/int)").to_i,
			"cookingRecipes" => xml.xpath("count(//Farmer/cookingRecipes/item)").to_i,
			"craftingRecipes" => xml.xpath("count(//Farmer/craftingRecipes/item)").to_i,
		}
		maps.each do |k, v|
			values[k] = xml.at_xpath(v).content
		end

		puts ">> #{values}"

		File.open(out, "a") do |fp|
			puts "Writing to #{out}..."
			csv = CSV.new(fp)
			csv << values.values.map(&:to_s)
		end

		backup = "#{path}.#{values["stats/daysPlayed"]}.xml"
		File.open(backup, "w") do |fp|
			puts "Writing backup to #{backup}..."
			fp.write(input)
		end

		last_mtime = File.mtime(path)
	end

	puts "[#{Time.now}] waiting..."
	sleep(30)
end
