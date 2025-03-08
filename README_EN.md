# Solar System Simulation

[中文](README.md) | English

An interactive solar system simulation application developed with Flutter, demonstrating planetary motion and characteristics.

## Project Introduction

This project is a solar system simulation application that intuitively demonstrates the orbital trajectories, rotation characteristics, and physical features of planets in the solar system through beautiful animations and interactive effects. The application is developed using the Flutter framework, featuring smooth animations and a responsive user interface.

## Features

- **Planet Simulation**: Simulates the orbital trajectories and rotation of the eight planets in the solar system
- **Visual Effects**: Beautiful planet rendering, including special features (such as Saturn's rings, Jupiter's Great Red Spot, etc.)
- **Interactive Controls**:
  - Zoom and pan functionality for free solar system exploration
  - Click to select planets and view detailed information
  - Animation speed adjustment
  - Pause/play control
- **Planet Information**: Displays basic data and characteristic descriptions for each planet
- **Immersive Experience**: Starry background and gravitational field visual effects

## Technical Implementation

- **Flutter Framework**: Cross-platform application development using Flutter
- **Custom Drawing**: Implementation of the solar system drawing using CustomPainter
- **Animation System**: Control of planetary motion using AnimationController
- **Physical Model**: Simulation of planetary orbital motion and rotation
- **Responsive UI**: User interface that adapts to different screen sizes
- **Gesture Recognition**: Implementation of zoom, pan, and click interactions

## Project Structure

```
lib/
├── main.dart              # Application entry
├── models/               # Data models
│   ├── planet.dart       # Planet model
│   └── solar_system.dart # Solar system model
├── painters/             # Custom drawing
│   └── solar_system_painter.dart # Solar system painter
└── screens/              # Interfaces
    └── solar_system_screen.dart  # Main screen
```

## Planet Characteristics

The application simulates the eight planets in the solar system, with each planet having the following characteristics:

- Orbital radius and period
- Planet size and color
- Rotation period and angle
- Special visual features (such as Saturn's rings, Jupiter's Great Red Spot, etc.)
- Planet description information

## Running the Project

Ensure you have the Flutter development environment installed, then execute:

```bash
# Get dependencies
flutter pub get

# Run the application
flutter run
```

## System Requirements

- Flutter SDK: ^3.7.0
- Dart SDK: ^3.0.0
- Supported Platforms: Android, iOS, Web, Windows

## Development and Contribution

Welcome to submit issues and improvement suggestions! If you want to contribute to the project, please follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.