require 'cgi'
pages << {
    page_type: 'products_search',
    method: 'GET',
    url: 'https://www.rohlik.cz/services/frontend-service/products/300108038?offset=0&limit=25',
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'page' => 1
    }


}

search_terms = ['Red Bull', 'RedBull', 'Energidryck', 'Energidrycker']
search_terms.each do |search_term|

  pages << {
      page_type: 'products_search',
      method: 'GET',
      url: "https://www.rohlik.cz/services/frontend-service/search/#{CGI.escape(search_term)}?companyId=1&limit=25&offset=0",
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1
      }


  }

end