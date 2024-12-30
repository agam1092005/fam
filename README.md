# fam

This Flutter project implements a dynamic and contextual card system closely resembling the provided Figma design. It leverages Provider for state management and Shared Preferences for local caching.

## Submission
- All required files are available in the `submission` folder, which includes:
    - `functions.md`
    - APK file
    - iOS recording

## Features

### 1. **Long Press Functionalities**
- Available on **HC3** design type:
    - **Remind Later**
    - **Dismiss Now**
- Notes:
    - As it was not mentioned whether i can use PUT request for handling dismiss functionality, i used cache to store the id of HC3 and id of the card.
    - Utilizes **Shared Preferences** to cache the dismissed card's ID.
    - Removes the card from the current state using the cached ID.

### 2. **Design Types**
- The project supports the following design types as per the provided documentation:
    - **HC1**
    - **HC3**
    - **HC5**
    - **HC6**
    - **HC9**


## Project Structure

### 1. **Constants**
- File: `constants.dart`
- Contains predefined constants for styling such as:
    - Border radius
    - Padding
    - Background color

### 2. **Formatter**
- File: `formatter.dart`
- Includes utility functions to:
    - Format titles
    - Format descriptions
    - Handle text entities

### 3. **Dynamic Container**
- File: `dynamic_container.dart`
- The primary container that returns the final contextual card required for the application.

### 4. **Components**
- File: `components.dart`
- Contains all the core functions used in creating the dynamic container.
- Detailed documentation for these functions can be found in `functions.md`.

### 5. **State Management**
- **Provider** is used for state management.
- File: `card_provider.dart`
    - Utilizes `api_service.dart` to handle GET requests for fetching data.

### 6. **Home Screen**
- File: `home_screen.dart`
- The sole screen in the project.
- Closely mirrors the Figma design provided.


## Additional Notes
- Inline comments are provided throughout the codebase.
- For a detailed summary of specific functions, refer to the `functions.md` file.

---
