# Loan Eligibility Prediction System - Project Summary

## Overview
The **Loan Eligibility Prediction System** is a Flutter-based application designed as a decision-support prototype. It provides an intuitive, multi-step interface to evaluate loan applicants by collecting their personal and financial information, then simulating a machine-learning-based eligibility prediction. 

## Technology Stack
- **Framework:** Flutter (Dart ^3.11.0)
- **State Management:** Core Flutter Stateful Widgets (`setState`)
- **Routing:** Handled via a shell screen (`MainShellScreen` in `main.dart`) with `NavigationRail` for desktop and `NavigationBar` for mobile/tablet.

## Architecture & Directory Structure
The project follows a standard and clean Flutter architectural pattern:
- **`lib/main.dart`**: Entry point and main shell setup that manages the navigation between Home, Assessment Flow, and Dashboard.
- **`lib/models/`**: Contains the data structures:
  - `Applicant`: Personal details (employment type, education, dependents).
  - `LoanApplication`: Financial details (income, existing EMI, credit score, loan amount requested).
  - `PredictionResult`: The output of the evaluation model (probability, risk level, positive factors, concerns).
- **`lib/screens/`**: UI implementations for different pages:
  - `home_screen.dart`: Landing page explaining the tool.
  - `dashboard_screen.dart`: Analytics view displaying aggregated metrics of predictions (e.g., eligible vs. non-eligible distribution).
  - **Assessment Flow**: `applicant_screen.dart`, `financial_screen.dart`, `loan_details_screen.dart` (data collection), `processing_screen.dart` (simulated delay), `result_screen.dart`, and `assessment_details_screen.dart` (results display).
- **`lib/services/`**: Contains the core logic.
  - `prediction_service.dart`: Currently implements a `MockPredictionService` that simulates ML inference. It calculates eligibility based on a weighted scoring system.
- **`lib/theme/`**: `app_theme.dart` provides a centralized design system using a Navy, Blue, and White color palette.
- **`lib/widgets/`**: Reusable UI components like `custom_text_field.dart`, `dropdown_field.dart`, and `result_card.dart`.

## Core Logic & ML Simulation
The application uses a weighted scoring algorithm to simulate a credit assessment model. The weights are distributed as follows:
- **Credit Score:** 30%
- **Income to Loan Ratio:** 25%
- **Existing Monthly EMI Burden:** 15%
- **Employment Stability/Type:** 15%
- **Dependents:** 10%
- **Education Background:** 5%

An applicant requires a cumulative score probability of `>= 55%` to be considered eligible. The system generates dynamic feedback, including positive factors and areas of concern based on these metrics.

## Key Features
- **Responsive Design:** Adapts smoothly between desktop (using a side navigation rail) and mobile views (using a bottom navigation bar).
- **Demo Mode:** Allows users to quickly populate form fields with dummy data (`Applicant.demo()`, `LoanApplication.demo()`) or run a complete 1-click evaluation for academic presentation purposes.
- **Analytics Dashboard:** Provides a visual overview of assessment statistics and recent evaluations.
