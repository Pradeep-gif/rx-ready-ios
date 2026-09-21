# Rx Ready

A compact native iOS portfolio project for a pharmacy-style refill experience. It demonstrates the engineering decisions that matter in a production mobile app without pretending to connect to a real pharmacy system.

## What it demonstrates

- SwiftUI with `@Observable` state management and accessible Dynamic Type layouts
- Async/await networking behind a protocol, making production and preview data interchangeable
- Retry-friendly loading, clear error states, and deterministic mock data
- Privacy-conscious event logging (no medication name or prescription identifier is logged)
- Unit tests for domain logic and the view model
- GitHub Actions quality gate for `swift test`

## Run it

Open `Package.swift` in Xcode 16+ and run the `RxReadyDemo` scheme on an iOS 17+ simulator. The project currently uses `MockPrescriptionService`, so it requires no account or health data.

## Architecture

`View → RefillViewModel → PrescriptionServing → URLSessionPrescriptionService`

The included mock is injected at the app boundary. A real app would replace it with an authenticated, HIPAA-reviewed backend client; protected health information must never be sent directly to a third-party analytics platform.

## Resume wording

**Rx Ready — iOS portfolio project:** Built a SwiftUI medication-refill dashboard using async/await, protocol-based API clients, accessibility support, privacy-safe telemetry, unit tests, and GitHub Actions CI.

## Important

This is a demonstration app. It contains fictional prescriptions only and is not medical software.
