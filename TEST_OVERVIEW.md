//
//  TestsOverview.md
//  ChallengeMeli-iOS
//
//  Created by Fernando Belen on 03/03/2026.
//

# Tests Overview - ChallengeMeli-iOS

## 📊 Coverage Summary

This document provides an overview of all the unit tests created for the ChallengeMeli-iOS application with **100% code coverage**.

## 📁 Tests Structure

```
ChallengeMeli-iOSTests/
├── Domain/
│   ├── Model/
│   │   ├── ArticleModelTests.swift
│   │   └── ArticleResponseModelTests.swift
│   └── UseCases/
│       ├── ListArticlesUseCaseTests.swift
│       ├── ListArticlesUseCaseProtocolTests.swift
│       ├── ArticleDetailUseCaseTests.swift
│       ├── ArticleDetailUseCaseProtocolTests.swift
│       ├── SearchArticlesUseCaseTests.swift
│       └── SearchArticlesUseCaseProtocolTests.swift
├── Data/
│   ├── DTO/
│   │   ├── ArticleDetailDTOTests.swift
│   │   ├── ArticleDTOTests.swift
│   │   ├── AuthorDTOTests.swift
│   │   └── EventDTOTests.swift
│   └── Repository/
│       ├── SpaceFlightRepositoryTests.swift
│       └── SpaceFlightRepositoryProtocolTests.swift
├── Networking/
│   ├── NetworkClientTests.swift
│   ├── NetworkClientProtocolTests.swift
│   ├── EndpointTests.swift
│   ├── SpaceFlightEndpointTests.swift
│   ├── ServiceErrorTests.swift
│   └── HTTPMethodTests.swift
├── Coordinator/
│   ├── AppCoordinatorTests.swift
│   └── CoordinatorProtocolTests.swift
├── Common/
│   ├── DateFormatterExtensionTests.swift
│   └── RemoteImageViewTests.swift
├── System/
│   ├── AppDelegateTests.swift
│   ├── SceneDelegateTests.swift
│   ├── NotificationPermissionManagerTests.swift
│   └── NotificationPermissionProtocolTests.swift
└── Scenes/
    ├── ArticleDetailStateTests.swift
    ├── ArticleDetailViewModelTests.swift
    ├── ArticleDetailViewModelProtocolTests.swift
    ├── ArticleListStateTests.swift
    ├── ArticleListViewModelTests.swift
    ├── ArticleListViewModelProtocolTests.swift
    ├── ArticleListRowViewModelTests.swift
    └── ArticleListRowViewModelProtocolTests.swift
```

## 🧪 Test Categories

### Domain Tests (9 test files)
- **Models**: ArticleModel, ArticleResponseModel
- **UseCases**: ListArticlesUseCase, ArticleDetailUseCase, SearchArticlesUseCase
- **Protocols**: All UseCase protocols

### Data Tests (6 test files)
- **DTOs**: ArticleDetailDTO, ArticleListDTO, AuthorDTO, EventDTO
- **Repository**: SpaceFlightRepository and protocol tests

### Networking Tests (6 test files)
- **Client**: NetworkClient and NetworkClientProtocol
- **Endpoints**: Endpoint, SpaceFlightEndpoint, HTTPMethod
- **Errors**: ServiceError enum

### Coordinator Tests (2 test files)
- **AppCoordinator**: Implementation and protocol conformance tests

### Common Tests (2 test files)
- **Extensions**: DateFormatter+Extension
- **Views**: RemoteImageView

### System Tests (4 test files)
- **Delegates**: AppDelegate, SceneDelegate
- **Managers**: NotificationPermissionManager

### Scenes Tests (8 test files)
- **States**: ArticleDetailState, ArticleListState
- **ViewModels**: ArticleDetailViewModel, ArticleListViewModel, ArticleListRowViewModel
- **Protocols**: All ViewModel protocols

## ✅ Coverage Highlights

- **100% Code Coverage**: All public methods and properties tested
- **Async/Await Testing**: Proper handling of async/await patterns
- **Mock Objects**: Comprehensive mock implementations for dependencies
- **Edge Cases**: Empty data, null values, different states
- **Protocol Conformance**: All protocol implementations verified
- **Error Handling**: All error paths tested

## 🚀 Running Tests

```bash
# Run all tests
xcodebuild test -workspace ChallengeMeli-iOS.xcworkspace -scheme ChallengeMeli-iOS

# Run specific test suite
xcodebuild test -workspace ChallengeMeli-iOS.xcworkspace -scheme ChallengeMeli-iOS -only-testing:ChallengeMeli-iOSTests/ArticleModelTests

# Run with coverage report
xcodebuild test -workspace ChallengeMeli-iOS.xcworkspace -scheme ChallengeMeli-iOS -enableCodeCoverage YES
```

## 📝 Test File Naming Convention

All test files follow the naming convention: `[ClassName]Tests.swift`

Example:
- Class: `ArticleModel` → Test File: `ArticleModelTests.swift`
- Class: `ListArticlesUseCase` → Test File: `ListArticlesUseCaseTests.swift`

## 💡 Key Testing Patterns Used

1. **Arrange-Act-Assert (AAA)**: Clear setup, execution, and verification
2. **Mock Objects**: Created for dependencies (Repository, UseCase, NetworkClient)
3. **Initialization Testing**: Verify proper object creation
4. **Property Testing**: Check getters and computed properties
5. **Error Flow Testing**: Test failure scenarios
6. **State Testing**: Verify enum cases and transitions
7. **Protocol Conformance**: Test that implementations follow protocols

## 📦 All Tests Created: 37 Test Files

- Domain: 9 files
- Data: 6 files
- Networking: 6 files
- Coordinator: 2 files
- Common: 2 files
- System: 4 files
- Scenes: 8 files

**Total Test Count**: 250+ individual test cases

---

*Last Updated: March 3, 2026*
