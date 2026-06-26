# ADR-0009 — Vite + React for the web (not Next.js)
**Status:** Accepted
**Date:** 2026-06-19

## Context
React is fixed (ADR-0005). The wrapper choice is Next.js (meta-framework, SSR) vs. Vite SPA. The deciding question: will Google ever crawl these pages? Our app is 100% behind login.

## Decision
**Vite + React + React Router + TanStack Query**, a client-rendered SPA talking to NestJS over REST.

## Consequences
**Good:** simpler, cheaper to host, faster to develop for a login-only app; no unused SSR machinery; shares React mental model with React Native; clean separation from our standalone backend (no duplicate API logic in the front-end).
**Cost:** no SSR/SEO — irrelevant here; easy migration to Next.js later if a public marketing surface is ever needed.
**Open:** none.
