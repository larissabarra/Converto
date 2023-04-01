
# Converto

Converto is a simple exercise that uses the [Frankfurter API](https://www.frankfurter.app/docs/) to fetch an display currencies and exchange rates.


#### 🚀  Features

- 📝 List of currencies
- 🪙 Latest exchange rates
- 💱 Currency conversion


#### 🧱 Technical details

- SwiftUI with MVVM architecture
- Cache using NSCache 
- Requests using URLSession
- Localisation
- UI tests using [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs/) for fixtures
## Future work

### Future features
- ⭐️ Favourite currencies
- 💹 Historical exchange rates
- 📲 Offline cache and conversions

### ⚙️ Technical improvements
#### 🗓️ Short term
- Refactor UI tests for readability
- Isolate cache behind generic protocol and unit test cache usage on currency service (work in progress in `tech/generic-cache` branch)
- Refactor long `convert` method in `ConversionsTabViewModel`
- Fully unit test APIService
- Isolate UI Components
- Dark mode

#### ⏳ //TODO: eventually
- Integration tests
- Implement Combine and use @MainActor for view models
- Design system
- Localise currency names
- Full accessibility
- Logging and monitoring
