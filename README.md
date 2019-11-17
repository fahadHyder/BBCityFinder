# BBCityFinder
Repo contains CityFinder application which filter cities based on search term.

## Data

* Used a DataSource class to load the json file(cities.json).
* Converted cities in json file to array of CityModel which is conform to Decodable.
* Also made CityModel conforms to Hashable protocol to use the set collection.
* Sorted CityModel array based on city name, So that we can directly use that array to populate the table

## Search

* Used async processing to keep the app responsive.
* Used result of previous search. Searching for "Ab" will only be successful if searching for "A" was successful as well. So if last search was a substring from current search, take the output array of previous search as an input.
* Used dictionary to group CityModel array to country as key
* Used Set collection to avoid duplicate objects.
    ### Implementation
    * If search term is empty, load the data array with elements from DataSource
    * If there is a previous search and new serch term starts with previous search term.
        * Create a CityDictionary with previous filtered array.
        * Call search function with Search term, previous filtered array and CityDictionary.
        * Update filterArray with output from search function.
    * If this is first search
        * Call search fucntion with pre loaded city array, CityDictionary and search term.
        * Update filterArray with output from search function.
    * update the previous search term with new keyword

    ### Search function
    It will take 3 paramters. Search Keyword, Array of Cities, Dictionary of Cities with country as Key.
    
    * If search term lenght is less than 3.
        * Get all keys from CityDictionary.
        * Filter key based on search term.
        * Add all city elments from CityDictionary to new array which matches keys in FilteredKeys
    * Filter the Array of Cities based on the search term and add to new Array.
    * Append the elements above two arrays.
    * Create a Set and insert elements from above operation.By doing this we can avoid duplicate elements.
    * Sort the Set by city name and return the result.
     
