# CryptoBuddy

CryptoBuddy provides real-time data of popular digital currencies
and allows users to build their own portfolios.
Data is fetched via the [CoinGecko API](https://www.coingecko.com/en/api) 
using the [coingecko_api](https://pub.dev/packages/coingecko_api) wrapper. 

### Currently implemented features

- **Cryptocurrency Listing**: List of 250 cryptocurrencies, displaying information such as
    the current price, price change percentage, name and ticker.


- **Search Functionality**: Effortlessly search through the list of cryptocurrencies 
    to quickly find and view details about a specific coin.


- **Sorting Options**: Sort the cryptocurrency list based on various criteria, such as market cap,
    current price, or price change percentage making it easier to analyze and compare different cryptocurrencies.


- **Detailed Coin Information**: Upon selecting a specific cryptocurrency from the list, users
    are directed to a dedicated page displaying extensive information about the coin.


### On the horizon

These functionalities are planned to be implemented and tested before the end of the project deadline.

- **Portfolio building**: Add or remove cryptocurrencies from your portfolio at will. There will be a dedicated
    page for the portfolio showing current balance and data for all owned assets.
    Adding and removing can be done via the detailed coin page or on the portfolio page itself.


- **Favorites Selection**: Add specific coins to your list of favorites and
    filter the list with all currencies for quick access.


-  **Price Visualisation**: Line charts for the value change of a specific coin and the portfolio

These functionalities are 'nice-to-have' and might not be implemented depending on the remaining time:


- **AI generated descriptions**: Generate an info text for each coin with OpenAI's API.


- **Settings Page**: Provides options to change color scheme and currency.


- **Dedicated Home Page**: Gives access to the settings page, shows current portfolio value, a currency converter
    and  favored cryptocurrencies.

### CoinGecko API limitations

This app makes use of the free Demo(Beta) plan. Plans can be viewed [here](https://www.coingecko.com/en/api/pricing). <br>

Max API calls per month: 10k <br>
Max API calls per minute: 30