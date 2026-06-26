# ADR-0010 — React Native (with Expo) for mobile
**Status:** Accepted
**Date:** 2026-06-19

## Context
Decision 6 weighed React Native vs. Flutter (Dart) vs. Kotlin Multiplatform (Kotlin). Two of three would unwind the unified-TypeScript decision (ADR-0005).

## Decision
**React Native with Expo**, Android first then iOS, sharing TypeScript types and business logic with web and backend.

## Consequences
**Good:** stays in the one-language stack; shares React patterns with the Vite web app; biggest talent pool/ecosystem; performance is imperceptibly different for a standard business app like ours.
**Cost:** KMP is arguably the rising enterprise cross-platform choice — but it only fits a Kotlin backend, which we don't have. Noted as a great future learning target on a Kotlin project.
**Open:** none.
