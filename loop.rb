require "active_record"
require_relative "aspect"
require_relative "item"
require_relative "category"
require_relative "photo"
require "open-uri"
require "nokogiri"
require "rebay"

searches = ["Michael", "NWT Michael Stars", "Loro Piana", "NWT Jimmy", "NWOT Christian", "NIB", "NIB Lolita", "NWB Sterling", "NEW", "Miu Miu", "Tod", "Taryn Rose", "Lacoste", "NWT Line", "NWT Melange", "NWT The Fillmore", "NWT Bela", "CHANEL Silver", "NWT Tart", "NWOT Manolo", "Carmen Marc", "NWT ZOA", "NWT DKNY", "Steve Madden", "Anya Hindmarch", "Rag", "NWOT Chan", "NWT Rich", "Moschino Floral", "Lauren Merkin", "NWT Bobby", "NWT Kim", "Hyde Collection", "YSL", "PRADA", "Giuseppe Zanotti", "Christian Dior", "NWT 7 For All", "Alexander McQueen", "NWT Emporio", "Gypsy", "James Perse", "Marika Charles", "NWT Generation", "L.A.M.B.", "NWT Red", "NWT Splendid", "DREW", "NWT DWP", "La Sportiva", "Lucchese", "7 For All", "FENDI Brown", "NWT Marrakech", "Piazza Sempione", "Chanel", "NWT Nicole", "Rodo Black", "Marrakech", "Burberry London", "Lilly Pulitzer", "Marrakech", "NEW Neiman", "Citizens Of Humanity", "Adriano Goldschmied", "Booby Jones", "PRADA Black", "Polo Ralph", "NEW", "NEW Coach", "David Meister", "MM Couture", "NWT Sao", "Robin", "Soybu", "NWT Soybu", "Rachel Roy", "Cynthia Rowley", "NWT Ingloa", "UNIQLO", "Vera Bradley", "Tracy Reese", "NWT Frank", "NWT Beverly", "BCBG Max", "Alice", "Heidi Weisel", "Saks Fifth", "Nils", "Pure Amici", "Ermengildo Zegna", "Oscar De", "Haute Hippie", "Barry", "Barry Kieselstein-Cord", "Moschino Cheap", "Monique Lhullier", "NWT Nike", "NWT Ella", "Peruvian Connection", "White House", "Dr. Martens", "Boston Proper", "Balenciaga", "Vineyard Vines", "NWT Rachel", "Bogner", "J. Crew", "Laundry", "Dina Bar", "Tadashi", "Fabiana Filippi", "Twelfth Street", "Blumarine", "Foley", "NWT BCBG", "NWT", "NWT Halston", "NWT Armani", "NWT Pauw", "Ann Taylor", "NWT Rebecca", "Viridis Luxe", "Missoni", "NWT Vince", "Babakul", "Anthropologie HD", "NWT Banana", "Diane Von", "Maeve Anthropologie", "NWT Parker", "Tart", "Helmut Lang", "Parker", "Jill Stuart", "Chaiken", "Burberry Black", "Cedric Charlier", "Paul Green", "Thread Social", "Stop Staring", "Pauw Amsterdam", "Christian Lacroix", "Nicole Miller", "Carmen Marc", "Balenciaga Edition", "Carven Red", "Poloma Renzi", "Louis Vuitton", "Mandalay", "Joseph", "NWT Lafayette", "Chanel Black", "NWOT St. John", "Lee Angel", "Rina Limor", "Calypso", "Jovani", "Stuart Weitzman", "Express Champagne", "NWT Eliza", "Frengii", "Craig Taylor", "Finley", "CHANEL", "Tommy Bahama", "S-Twelve", "XCVI", "Lucky Brand", "CP Shades", "Harrods Knightsbridge", "Love Tanjane", "Valentino Pink", "Renuar", "Young Fabulous", "Charles Chang", "NWOT Christian", "Tahari Arthur", "Christian Louboutin", "Albert Nipon", "Becky", "Le Suit", "NIB Franco", "NWT Bailey", "Ron White", "NWT Diane", "Gucci Silk", "Homer Reed", "NWT Drew", "Ted Baker", "NIB Puma", "NWT Cache", "Puma", "Colosseum White", "Tart Green", "NWOB Cole", "NWT Elie", "Nicole Miller", "NWT Maria", "Bianca Nero", "Yves Saint", "Gallotti", "Donald J", "Preen Line", "1932 Chicago", "Bally Black", "Ropez", "BCBG Max", "Grayse", "John Galliano", "Ermenegildo", "Rickie Freeman", "Ugg Australia", "Citizens", "Bally", "Miss Me", "Furla White", "Hart", "NWT Miss", "Dana Buchman", "Tahari", "Gary Graham", "Patterson J", "NWT Courage", "Lanvin Red", "NEW Ralph", "NWT Mother", "Coach Brown", "Patricia Rhodes", "Bottega Veneta", "NWT Calvin", "NWT Tibi", "NWT Michael", "NWT Yoana", "NWT Bella", "Chanel Perforated", "NWT Dolce", "Stella McCartney", "Badgley Mischka", "Armani Collezioni", "NWT Escada", "Escada Beige", "NWT Ralph", "Carolina Herrera", "Crumpet", "James Perse", "Salvatore", "Neiman Marcus", "Charlotte Tarantola", "Loro Piana", "Evovorro", "Walter Voulaz", "Komarov Gray", "Arden B.", "Michael Dawkins", "La Rok", "J.Crew", "Prada", "PRADA", "Gucci", "Manolo Blahnik", "Jimmy Choo", "Brunello Cucinelli", "Gunex Brunello Cucinelli", "Ralph Lauren", "Ralph Lauren Black Label", "Trina Turk", "Polo Ralph Lauren", "Ralph Lauren Collection Purple Label", "Adriano Goldschmied", "Tracy Porter", "Lululemon", "Theory", "Rebecca Taylor", "Joie", "Splendid", "Vince", "Witness", "Vince Camuto", "VInce", "Paper Crown", "Hudson", "7 For All Mankind", "Seven 7 for All Mankind", "True Religion", "Seven for All Mankind", "Seven 7 For All Mankind", "J Brand", "J. Brand", "Mother", "Maxmara", "Lanvin", "Faliero Sarti", "Bajra", "Belle Fare", "Nordstrom", "Neil Barrett", "Missoni", "Alberta Ferretti", "Angel Sanchez for Bergdorf Goodman", "Bill Blass", "Jean LaFont", "Oliver Peoples", "Lafont", "Zella", "prAna", "Be Present", "Nike", "Bailey 44", "Juicy Couture", "Fendi", "CHANEL", "Louis Vuitton", "Joan Vass", "Lida Baday", "Michael Kors", "T Bags", "Alice + Olivia", "Marc Jacobs", "kate spade", "Chanel", "Celine", "Phoebe Couture", "Daniels Swarovski", "Barney", "Judith Leiber", "Kim White", "Carlisle", "Paige Hamilton Designs", "Bottega", "Rodo", "Lauren Scherr", "Malandrino", "Max Mara", "Camilla and Marc", "Rebecca Minkoff", "Anne Fontaine", "Valentino Garavani", "Vaentino Garavani", "Valentino", "Red Valentino", "Velet", "Velvet", "Rich", "Elie Tahari", "Laundry by Shelli Segal", "Drama", "Metradamo", "DKNY", "Ecru", "Nanette Lepore", "Graham and Spencer", "Graham", "Michael Stars", "Yoana Baraschi", "SW3", "Drew", "Rich and Skinny", "Sanctuary Denim", "Chan Luu", "Julienne W", "Burning Torch", "Cole Haan", "Weston Wear", "Burberry", "Rory Beca", "Giorgio Armani", "Yoyo Yeung", "Goddis", "Black Halo", "Amanda Uprichard", "Generation Love", "AKRIS", "Akris for Bergdorf Goodman", "Akris Bergdorf Goodman", "Akris", "St. John", "St. John Collection", "St. John Caviar", "St. John Sport", "St. John Couture", "ESCADA", "Escada", "Elizabeth and James", "DVF", "Diane Von Furstenberg", "Diane von Furstenberg", "Dolce and Gabbana", "Dolce", "Rock", "Rock and Republic", "PRVCY", "Kay Unger", "Paige", "Paige Hamilton Design", "DL 1961", "BCBG Maxazaria", "BCBG Maxazria", "BCBG MAX AZRIA", "BCBGeneration", "3.1 Phillip Lim", "Just Cavalli", "Mason", "Current Elliot", "Etro", "Rene Lezard", "Salvatore Ferragamo", "Zac Posen", "Donald J Pliner", "Stuart Weitzman", "Yves Saint Laurent", "Agnona", "Me + Em", "Oscar de la Renta", "Comme des Garcons", "Proenza Schouler", "Pronza Schouler", "XCVII", "Vivienne Westwood", "Attilio Giusti Leombruni", "Attillo Giusti Leombruni", "Donna Karan", "Donna Karan Collection", "Catherine Malandrino", "Narcisco Rodriguez", "Brian Atwood", "Vicky Tiel Couture", "Vicky Tiel", "Richard Tyler", "Richard Tyler Couture", "Temperley", "Carmen Marc Valvo", "Charles Chang-Lima", "NIB Sofft", "Chloe", "NEW Belgian", "Alexander", "Adrianna Papell", "Vera Wang", "Jason Wu", "Jon", "Valentino Roma", "Tory Burch", "Pedro Garcia", "Double D", "Ralph Lauren", "Chanel Brown", "NEW Harley", "Rebecca Minkoff", "Rena Lange", "Armani Collezoni", "Lafayette", "El Daws", "NIB Stetson", "Ammons", "NIB Resistol", "NWT Yoana", "NIB Az-Tex", "NWT Oscar", "Alexander Wang", "Cache", "Inhabit", "360 Cashmere", "St. John Sport", "Coach", "Moschino", "St. John", "The North Face", "Madewell", "Ralph Lauren", "St. John Evening", "Ralph Lauren", "NWT Madewell", "Patterson J", "St. John Basics", "Saint Laurent", "Prada Black", "NWOT Sesto", "NWOT Icon", "Carlos Falchi", "Hermes Silk", "Seven For", "Lululemon Short", "Prada Purple", "Ralph Lauren", "Chanel", "Oscar de", "Akris Punto", "Hunter", "Peggy Jennings", "Free People", "Calvin Klein", "Splendid Swim", "Piazza Sempione", "NWT Label", "NWT Ecru", "NWT Yoana", "Josie Natori", "Armani Collezioni"]

location = __FILE__.gsub("loop.rb","")

#configure ActiveRecord
begin
	ActiveRecord::Base.establish_connection(YAML::load(File.open("#{location}database.yml")))
rescue Exception => e
	puts "Failed to connect to datbase: #{e.message}."
	return
end

#configure Rebay
Rebay::Api.configure do |r|
	r.app_id = 'AllForFu-8c44-42d9-8f97-90711eb79c87'
end


finder = Rebay::Finding.new

loop {

	searches.each do |search|
		puts "Searching for #{search}..."
		#search
		response = finder.find_items_by_keywords({:keywords => search,
			"itemFilter(0).name"=>"Seller", "itemFilter(0).value(0)" => "allforfunds"}).response
		if response["ack"] != "Success" then
			puts "'#{search}' failed:\n #{response}"
			next
		end

		search_result = response["searchResult"]
		if search_result["@count"] == 0 then
			puts "'#{search}' had no results"
			next
		end

		#setup items
		items = search_result["item"]
		if items == nil then
			puts "No items :("
			next
		end
		
		items.each do |item|

			item_id = ""
			only_one = false

			if item.class != Hash then
				puts "Only one item for this search."
				item_id = item[-1]
				only_one = true
			else
				if item["itemId"] == nil then
					puts "No item id."
					next
				end

				item_id = item["itemId"]
			end

			shopper = Rebay::Shopping.new
			shopping_item = shopper.get_single_item({:ItemID => "#{item_id}"})
			shopping_item = shopping_item.response
			if shopping_item["Ack"] != "Success" then
				puts "Failed to get shopping item for #{item_id}. response: #{shopping_item}"
				if only_one then
					break
				else
					next
				end
			end


			shopping_item = shopping_item["Item"]
			if Item.where("eId = ?", item_id).first != nil then
				i = Item.where("eId = ?", item_id).first
				i.title = shopping_item["Title"]
				i.price = shopping_item["ConvertedCurrentPrice"]["Value"].to_f
				i.url = shopping_item["ViewItemURLForNaturalSearch"]
				i.save
				puts "Updated #{i.title}"

				if only_one then
					break
				else
					next
				end
			end


			i = Item.new
			i.eId = shopping_item["ItemID"]
			i.title = shopping_item["Title"]
			begin
				i.price = shopping_item["ConvertedCurrentPrice"]["Value"].to_f
			rescue
				puts "There was an erroring saving the price of object #{i.title}. Skipping..."
				next
			end
			i.url = shopping_item["ViewItemURLForNaturalSearch"]
			puts "Found item named #{i.title} with id #{i.eId}"

			if Category.where("eId = #{shopping_item['PrimaryCategoryID']}").first == nil then
				c = Category.new
				c.eId = shopping_item['PrimaryCategoryID']
				c.title = shopping_item['PrimaryCategoryName']
				c.save
				i.category = c
				puts "Found category named '#{c.title}' with Id: #{shopping_item['PrimaryCategoryName']}"
			else
				c = Category.where("eId = #{shopping_item['PrimaryCategoryID']}").first
				puts "Putting item in '#{c.title}'"
				i.category = c
			end
			i.save

			#get aspect values
			if shopping_item["ViewItemURLForNaturalSearch"] != nil then
				ebay_item_page = Nokogiri::HTML(open(shopping_item["ViewItemURLForNaturalSearch"]))
				cost = ebay_item_page.css("#fshippingCost")
				if cost.text.gsub(/\s+/, "") == "FREE" then
					i.shipping_price = 0.0
				else
					i.shipping_price = cost.text.gsub(/\s+/, "").to_f
				end

				photos = ebay_item_page.css("img[src*='auctionsound.s3.amazonaws.com']")
				photos.each do |photo| 
					p = Photo.new
					p.item = i
					p.url = photo.attr('src').gsub("thumbs_", "")
					p.is_gallery = 0
					p.save
				end

				if i.photos.first == nil  then
					puts "could not find photo. Getting Ebay's."
					photo = ebay_item_page.css("#icImg").first.attr("src")
					p = Photo.new
					p.item = i
					p.url = photo
					p.is_gallery = 0
					p.save
				end

				attributes = ebay_item_page.css(".attrLabels")
				attributes.each do |attribute|
					attribute_text = attribute.text.gsub("\n", "").gsub("\t", "").gsub(":","")
					attribute_text[0] = ""
					attribute_text[-1] = ""
					value_text = attribute.next_element.text.gsub("\n", "").gsub("\t", "")

					begin
						aspect = Aspect.new
						aspect.name = attribute_text
						aspect.value = value_text
						aspect.category = i.category
						aspect.item = i
						aspect.save
					rescue
						puts "Failed to save aspect."
					end
				end
			end

			if only_one then
				break
			end
		end
	end
	
	Item.where("purchased != 1").each do |item|
		puts "Syncing #{item.id}..."
		if item.purchased == 1 then
			next
		end
		shopper = Rebay::Shopping.new
		shopping_item = shopper.get_single_item({:ItemID => "#{item.eId}"})
		shopping_item = shopping_item.response
		if shopping_item["Ack"] != "Success" then
			next
		end
		shopping_item = shopping_item["Item"]
		if shopping_item["ListingStatus"] != "Active" then
			puts "Taking item (#{item.id}) down with status #{shopping_item["ListingStatus"]}"
			item.purchased = 1
			item.save
			next
		end
		ebay_item_page = Nokogiri::HTML(open(shopping_item["ViewItemURLForNaturalSearch"]))

		updated_photos = []
		photos = ebay_item_page.css("img[src*='auctionsound.s3.amazonaws.com']")
		photos.each do |photo| 
			p = Photo.new
			p.item = item
			p.url = photo.attr('src').gsub("thumbs_","")
			p.is_gallery = 0
			p.save
			updated_photos << p
		end

		if updated_photos.first == nil  then
			if ebay_item_page.css("#icImg").first != nil then
				photo = ebay_item_page.css("#icImg").first.attr("src")
				p = Photo.new
				p.item = item
				p.url = photo
				p.is_gallery = 0
				p.save
				updated_photos << p
			end
		end

		item.photos.each do |p| 
			if !updated_photos.include? p then
				p.destroy
			end
		end 
	end

	sleep(90.minutes)
}
