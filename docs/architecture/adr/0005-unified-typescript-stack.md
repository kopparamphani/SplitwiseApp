# ADR-0005 — Unified TypeScript stack (NestJS + React/Vite + React Native)
**Status:** Accepted
**Date:** 2026-06-19

## Context
Decision 1 asked which language the services use. The deeper question was strategy: best-tool-per-layer (e.g. Java backend + JS front) vs. one language everywhere. As a solo builder spanning backend, web, and mobile, cross-layer code/skill reuse matters more than matching big-enterprise team structure.

## Decision
Unify on **TypeScript** across all layers: **NestJS** for the 5 services, **React** for web, **React Native** for mobile. Shared types, validation, and contract code move across all three.

## Consequences
**Good:** one language and one mental model everywhere; web and mobile share React patterns; fastest path for a solo builder.
**Cost:** TypeScript/Node is less the "heavy enterprise backend" norm than Java; we trade some enterprise-stack familiarity for reuse.
**Open:** Release-2 OCR service was originally pencilled for Python; with this ADR we first try to keep it in the TS world.
