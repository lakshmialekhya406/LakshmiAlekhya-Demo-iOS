# Portfolio Demo App

## Overview
This project implements an MVVM architecture for fetching and displaying holdings from API. It consists of a Network Monitor, Manager, ViewModel, and View components, ensuring a clean separation of concerns and making the codebase easy to maintain and test.

## Screenshots
<div style="display: flex; justify-content: space-around;">
    <img src="https://github.com/user-attachments/assets/437c1302-8f34-45b6-a233-3df8a0cfc07c" height="400" alt="Holdings List View" style="margin: 0 10px;">
    <img src="https://github.com/user-attachments/assets/e2558489-4822-44d7-a573-e56edee184f7" height="400" alt="Holdings Summary View" style="margin: 0 10px;">
</div>

## Features
* Fetch holdings from API.
* Displays hldings in a list format.
* Handles loading states and error messages gracefully.

## Architecture
The project follows the MVVM design pattern, which consists of the following components:
* **Model**: Represents the data structure (e.g., HoldingData, HoldingsResponse).
* **View**: The views that present data to the user (e.g., PortfolioViewController, HoldingCell, SummaryView).
* **ViewModel**: Contains the business logic and acts as an intermediary between the Model and View (e.g., PortfolioViewModel).
* **Network Monitor**: Monitors network reachability(e.g., Network Monitor).
* **Manager**: Fetch data and manages the data(e.g., PortfolioManager).

## Usage
1. Launch the application.
2. The main screen will display a list of Holdings fetched from the API.
3. Tap on summary view to see the summary of all holdings.

## Unit Tests
The project includes unit tests for critical components:
* **Manager**: Tests to verify data fetching logic(i.e., PortfolioManagerTests).
* **ViewModel**: Tests to ensure proper state management and logic execution(i.e., PortfolioViewModelTests).
### To run the tests:
1. Open Xcode.
2. Select Product > Test or use the shortcut Command + U.

## Code Coverage
To check code coverage in Xcode, please follow these steps:

View Code Coverage Reports
* After running your tests, open the Report Navigator by pressing Command + 9 or selecting it from the View menu (View > Navigators > Report Navigator).
* Select the most recent test run.
* Click on the Coverage tab to view detailed coverage information.

Analyze Coverage Data
* In the Coverage report, you will see a list of files along with their coverage percentages.
* You can click on any file to see which lines of code were executed during testing, indicated by colored markers:
   1. Green: Lines that were executed.
   2. Red: Lines that were not executed.
