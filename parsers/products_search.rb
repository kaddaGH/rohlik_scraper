data = JSON.parse(content)
scrape_url_nbr_products = data['data']['totalHits'].to_i
current_page =page['vars']['page']
products = data['data']['productList']


# if ot's first page , generate pagination
if current_page == 1 and scrape_url_nbr_products > products.length
  nbr_products_pg1 = products.length
  step_page = 1
  while step_page*products.length <= scrape_url_nbr_products

    pages << {
        page_type: 'products_search',
        method: 'GET',
        url: page['url'].gsub(/offset=0/, "offset=#{products.length}"),
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => step_page+1,
            'nbr_products_pg1' => nbr_products_pg1
        }
    }

    step_page = step_page + 1


  end
elsif current_page == 1 and scrape_url_nbr_products <= products.length
  nbr_products_pg1 = products.length
else
  nbr_products_pg1 = page['vars']['nbr_products_pg1']
end


products.each_with_index do |product, i|

  pages << {
      page_type: 'product_details',
      method: 'GET',
      url: "https://www.rohlik.cz/services/frontend-service/product/#{product['productId']}/full?search_term=#{page['vars']['search_term']}&page=#{current_page + 1}&rank=#{ i + 1}",
      vars: {
          'input_type' => page['vars']['input_type'],
          'search_term' => page['vars']['search_term'],
          'product_rank' => i + 1,
          'page' => current_page ,
          'nbr_products_pg1' => nbr_products_pg1,
          'scrape_url_nbr_products' => scrape_url_nbr_products

      }
  }


end

