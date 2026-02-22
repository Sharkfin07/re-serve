# Re-Serve

<img width="1920" height="1080" alt="re-serve-header" src="https://github.com/user-attachments/assets/6abf2a0d-8720-4cf3-92ac-f4258babb12b" />

Re-Serve is a mobile application that connects surplus, still-edible food from vendors with people who need affordable meals. By allowing businesses to offer excess menu items at discounted prices, Re-Serve helps reduce food waste while making quality food more accessible to the community. Designed to be as intuitive as mainstream food delivery platforms, the app promotes sustainable consumption and supports a more responsible food ecosystem.

## Features

- Authentication (login/register) with secure token storage
- Food exploration: list, search, detail
- Like foods and view liked foods later
- Ratings and reviews
- Cart management (add/update/remove)
- Checkout flow with payment method selection
- Account management (profile edit, transactions)

## Tech Stack

- Flutter (Dart)
- State management: `flutter_bloc`
- Networking: `dio`
- Secure storage: `flutter_secure_storage`
- Env config: `flutter_dotenv`
- Images: `cached_network_image`
- Formatting: `intl`

## Project Structure

```
lib/
	core/
		config/          # Env config
	data/
		models/          # DTOs and model mapping
		services/        # API client + endpoints
		repositories/    # Data access layer
	presentation/
		bloc/            # BLoC events, states, logic
		screen/          # UI screens
		widgets/         # Reusable UI components
```

## Getting Started

### 1) Install dependencies

```
flutter pub get
```

### 2) Configure environment

Create a `.env` file in the project root:

```
API_KEY=your_api_key
BASE_URL=https://api.example.com
```

These are loaded via `EnvConfig` in [lib/core/config/env_config.dart](lib/core/config/env_config.dart).

### 3) Run the app

```
flutter run
```

## Demo

https://github.com/user-attachments/assets/ffc87ad6-072a-4119-a25c-3fe70d329141

## Notes

- Link to Pitch Deck: [Canva Link](https://www.canva.com/design/DAHByV5-IUs/uLtWsx4o9Mu8hfxlqKlA2Q/edit?utm_content=DAHByV5-IUs&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)
- The checkout flow intentionally uses a mock transaction response (API returns status only).
- Image loading uses caching with placeholders and error fallbacks.

## License

This project is for educational purposes.
