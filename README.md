# 🎬 MovieVault

A movie discovery app built with **UIKit**, **MVVM-C**, **Repository Pattern**, and **Swift Concurrency** using the TMDB API.

## Preview

---

## Features

- Browse Popular, Top Rated and Upcoming movies
- View movie details, cast and official trailers
- Pagination
- Repository-based in-memory caching
- Generic networking with URLSession
- Unit tests for ViewModels and Repository

---

## Tech Stack

- UIKit
- MVVM-C
- Repository Pattern
- URLSession
- Async/Await
- Codable
- Kingfisher
- Swift Testing

---

## Project Structure

```text
MovieVault
├── Config
├── Coordinator
├── Core
│   ├── Common
│   ├── Components
│   ├── Extensions
│   └── Networking
│       ├── Endpoints
│       ├── Models
│       ├── Repository
│       └── Services
├── Features
│   ├── Home
│   ├── Detail
│   └── MovieList
└── Resources
```

---

## Installation

1. Clone the repository.
2. Create `Config/Secrets.xcconfig`.
3. Add your TMDB API token:

```text
TMDB_TOKEN = YOUR_API_KEY
```

4. Run the project.

---

## Tests

- Repository Tests
- HomeViewModel Tests
- DetailViewModel Tests
- MovieListViewModel Tests
