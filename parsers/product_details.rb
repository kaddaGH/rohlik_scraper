data = JSON.parse(content)
data= data['data']['product']

promotion = (data['goodPriceSalePercentage']>0)? "-"+data['goodPriceSalePercentage'].to_s+"%" :""



availability = (data['inStock'] == true) ? '1' : ''
item_size_info = data['textualAmount']+data['productName']

price = data['price']

category = data['categories'][0]['name']

description = data['description'].gsub(/<[^<>]+>/, '').gsub(/[\n\s]+/, ' ').gsub(/,/, '.') rescue ''
brand = [
    'Carnation', '5-Hour Energy Shot', 'Zipfizz', 'Starbucks', 'CYRON', 'NCAA', 'Meilo', 'Chicago Bulls',
    'AMP','Spring', 'SlimFast', "Maxx", "Hell", "Powerking", "Jupí", "Oshee",
    "N-Gine", "Isostar", "Semtex", "Big Shock!", "Tiger", "Gatorade", "Pickwick", "Rauch", "Tesco",
    "Red Bull", "Nocco", "Celsius", "Wolverine", "Monster", "Vitamin Well", "Aminopro", "Powerade", "Nobe",
    "Burn", "Njie", "Boost", "Vive", "Black", "Arctic+", "Activlab", "Air Wick", "N'Gine",
    "4Move", "i4Sport", "BLACK", "Body&Future", "X-tense", "Booster", "Rockstar", "28 Black", "Adelholzener",
    "Dr. Pepper", "Topfit", "Power System", "Berocca", "Demon", "G Force", "Lucozade", "Mother", "Nos",
    "Phoenix", "Ovaltine", "Puraty", "Homegrown", "Running With Bulls",
    'Liquid Ice', 'All Sport', 'Kickstart', 'Bang', 'Full Throttle', 'Lyte Ade', 'Gamergy',
    'Ax Water', 'Propel', 'Nesquick', 'Up Energy', 'Wired Energy', 'Red Elixir',
    'Body Armor', 'Rip It', 'Fitaid', 'Focusaid', 'Partyaid', 'Lifeaid', 'Kicks Start', 'Bawls',
    'Xpress', 'Core Power', 'Runa', 'Zola', 'Outlaw', 'Uptime', 'Green Dragon', 'Gas Monkey',
    'Ruckpack', 'Xing', 'Clutch', 'Chew-A-Bull', 'Matchaah', 'Surge', 'Chew A Bull', 'Vitargo',
    'Star Nutrition', 'Monster Energy', 'Nutramino Fitness Nutrition', 'Olimp Sports Nutrition',
    'Belgian Blue', 'Maxim', 'Biotech USA', 'Gainomax', 'Chained Nutrition','TNT','Tchibo'
].find {|brand_name| data['productName'].downcase.include?(brand_name.downcase)} || ''


regexps = [
    /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
    /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
    /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
    /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
    /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
    /(\d*[\.,]?\d+)\s?([Oo]unce)/,
    /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
    /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
    /(\d*[\.,]?\d+)\s?([Ll])/,
    /(\d*[\.,]?\d+)\s?([Gg])/,
    /(\d*[\.,]?\d+)\s?([Ll]itre)/,
    /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
    /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
    /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
    /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
    /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
    /(\d*[\.,]?\d+)\s?([Cc]hews)/,
    /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
]
regexps.find {|regexp| item_size_info =~ regexp}
item_size = $1
uom = $2


regexps = [
    /(\d+)\s?[xX]/,
    /Pack of (\d+)/,
    /Box of (\d+)/,
    /Case of (\d+)/,
    /(\d+)\s?[Cc]ount/,
    /(\d+)\s?[Kk]s/,
    /(\d+)\s?[Cc][Tt]/,
    /(\d+)\s?[Pp]/,
    /(\d+)[\s-]?Pack($|[^e])/,
    /(\d+)[\s-]pack($|[^e])/,
    /(\d+)[\s-]?[Pp]ak($|[^e])/,
    /(\d+)[\s-]?Tray/,
    /(\d+)\s?[Pp][Kk]/,
    /(\d+)\s?([Ss]tuks)/i,
    /(\d+)\s?([Pp]ak)/i,
    /(\d+)\s?([Pp]ack)/i,
]
regexps.find {|regexp| item_size_info =~ regexp}
in_pack = $1
in_pack ||= '1'


product_details = {
    # - - - - - - - - - - -
    RETAILER_ID: '119',
    RETAILER_NAME: 'rohlik',
    GEOGRAPHY_NAME: 'CZ',
    # - - - - - - - - - - -
    SCRAPE_INPUT_TYPE: page['vars']['input_type'],
    SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
    SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
    SCRAPE_URL_NBR_PRODUCTS: page['vars']['scrape_url_nbr_products'],
    # - - - - - - - - - - -
    SCRAPE_URL_NBR_PROD_PG1: page['vars']['nbr_products_pg1'],
    # - - - - - - - - - - -
    PRODUCT_BRAND: brand,
    PRODUCT_RANK: page['vars']['product_rank'],
    PRODUCT_PAGE: page['vars']['page'],
    PRODUCT_ID: data['productId'],
    PRODUCT_NAME: data['productName'],
    PRODUCT_DESCRIPTION: description,
    PRODUCT_MAIN_IMAGE_URL: data['images'][0],
    PRODUCT_ITEM_SIZE: item_size,
    PRODUCT_ITEM_SIZE_UOM: uom,
    PRODUCT_ITEM_QTY_IN_PACK: in_pack,
    SALES_PRICE: price,
    IS_AVAILABLE: availability,
    PROMOTION_TEXT: promotion,
    EXTRACTED_ON:Time.now.to_s
}

product_details['_collection'] = 'products'

outputs<<product_details

