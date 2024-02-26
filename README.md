# CleanCodeMVVM

## Introduction

This project implements a simple and functional app, prioritizing functionality over fancy UI elements.

## Implementation Details

The app is implemented in both **UIKit** and **SwiftUI** To change the implementation:

1. Open the CleanCodeMVVMAssembly file.
2. Comment/uncomment in `registerFactories`.

### Components

- **Service:** 
  - `CleanCodeMVVMContentService`: Responsible for fetching data from the backend.
- **DataManager:** 
  - Utilized for persistence purposes within the application.
- **NetworkManager:** 
  - Designed specifically for making HTTP requests, with a focus on fulfilling the requirements of this projct. It also provides information regarding network reachability.
- **Swinject:** 
  - Employed for dependency injection within the application architecture.



