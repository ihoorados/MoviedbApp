# MoviedbApp

This is an iOS application that allows users to browse and discover movies from The Movie Database [TMDb](https://www.themoviedb.org). Built following best practices in software development, this app is designed with Clean Architecture and utilizes the MVVM design pattern, ensuring a well-organized and maintainable codebase.

## Architecture Overview

The project follows a structured and layered architecture:

+ Domain Layer: Contains the core business logic, representing the application’s use cases.
+ UseCase Layer: Defines the application-specific business rules and orchestrates the data flow between layers.
+ Presentation Layer: Manages the UI, handles user interactions, and communicates with ViewModels.
+ Data Layer: Responsible for fetching data from the TMDb.

### Architecture Diagram

![Architecture diagram](/cleanArchImage.png)

## Networking

- The app includes a simple HTTPClient with extension from URLSession that handles API requests.
- Requests are signed using the Decorator pattern, which wraps the network calls with the necessary authentication header containing the access token.


## Testing

- Unit Testing: Includes unit tests for ViewModels to ensure high-quality presentation logic.

## Includes:

- Reactive Programming: Utilizes Apple's Combine framework in combination with UIKit to create a responsive user interface.
- Light and Dark Modes: Full support for dynamic color schemes, providing an adaptive user experience.
- Pagination: Efficient handling of data with pagination, allowing users to navigate through extensive movie lists smoothly.
- Programmatically UI: UI components are laid out programmatically, promoting flexibility and clarity.

## Design Patterns:

- [MVVM Pattern](https://github.com/ihoorados/MoviedbApp/tree/master/MoviedbApp/Presentation/MovieList/ViewModel): The Model-View-ViewModel design pattern enhances testability and improves the maintenance of the user interface logic.
- [Dependency Injection](https://github.com/ihoorados/MoviedbApp/tree/master/MoviedbApp/Application): Implements Dependency Injection to enhance modularity and ease of testing.
- [Adapter Pattern](https://github.com/ihoorados/MoviedbApp/tree/master/MoviedbApp/Data/Mapper): Adapts DTO to Domain.
- [Singleton Pattern](https://github.com/ihoorados/MoviedbApp/blob/master/MoviedbApp/Data/Storage/CoreData/CoreDataStorage.swift): Manages shared resources with a single instance throughout the app lifecycle.
- [Decorator Pattern](https://github.com/ihoorados/MoviedbApp/blob/master/MoviedbApp/Infrastructure/Network/AuthenticatedNetworkSession.swift): Wraps request signing logic with access tokens, ensuring security and proper authentication.

# Setup

> To configure the app, follow these steps:

### Clone the Repository:

- git clone https://github.com/ihoorados/MoviedbApp.git
- cd MoviedbApp

> [!IMPORTANT]
> Visit The Movie Database [Developer](https://developer.themoviedb.org/docs/getting-started). 
> Create an account or log in if you already have one.
> Navigate to your account settings and create an API key.
> Copy the access token provided.



> [!TIP]
> Open the info.plist file in your Xcode project.
> Add a new key called accessTokeAuth and set its value to the access token you copied.

![Configure the token](/accessTokenHelperImage.png)

## How to use app

Open the Project:


- Open the project in Xcode and run it on your simulator or device.
Usage

Upon launching the app, users can:

- Search Functionality: Easily find specific movies using the search feature.
- To search a movie, write a name of a movie inside searchbar and hit search button.
- Movie Details: Access detailed information about each movie.
- Toggle Themes: Switch between light and dark modes based on user preference.

# Requirements 
- iOS: Minimum target is iOS 13.0
- Xcode: Version 12.0 or later
Installation


