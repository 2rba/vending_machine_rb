## Setup
1. fetch source `git clone git@github.com:2rba/vending_machine_rb.git`
2. cd to project folder `cd vending_machine_rb`
3. install dependencies `bundle install` (only needed for tests)
4. run tests `bundle exec rspec`

## Usage
The implementation consist of 2 classes: `VendingMachine` and `Product`
Product has only one attribute `price`
VendingMachine has 2 attributes: `balance` and `available_coin_counts`. \
`available_coin_counts` describes how many coins of each denomination are available in the machine. available_coin_counts purpose is to correctly give change.
VendingMachine has 3 methods: `accept_coin`, `request_product`, `return_change`.
- `accept_coin` accepts coin, adds it to the balance and updates `available_coin_counts`
- `request_product` checks if enough balance is available, if yes, returns true and updates `balance`. if not, returns false
- `give_change` returns available change and decrease `balance` and `available_coin_counts` accordingly

## Decisions
Assuming vending machine hardware can send events: 'coin inserted', 'product requested' the VendingMachine class has the corresponding methods.
Another assumption the machine hardware can give change if it receives the coins to count hash, (for ex. {'1p' => 3} means change should be 3 pennies).
request_product and give_change made as a separate methods to make it easier to update the business logic in the future. 
For ex. scenario when user adds coins, buy one product, buy another one, and then requests change.
- coins are defined as a strings
- if machine dont have enough change, it will return all available change therefore user might add coins again and buy something else


## Potencial improvements
- Coins could be defined as a class
- Real machine would require persistence to store balance and available coins
- "Controller" level is missing in this implementation, it would be responsible for user interaction
