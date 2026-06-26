# ADR-0016 — Ingress: Traefik now → Kong later
**Status:** Accepted
**Date:** 2026-06-24

## Context
ingress-nginx is retiring (no security patches after March 2026), so it's off the table. The community direction is the Gateway API, implemented by actively-maintained engines (Traefik, Kong, HAProxy, Envoy). Step 2 already planned a Kong gateway upgrade.

## Decision
**Traefik** as the ingress controller now; **graduate to Kong** at the edge-features stage, where Kong serves as unified ingress + API gateway (collapsing the placeholder NestJS gateway too).

## Consequences
**Good:** light, dashboard-visible, Gateway-API-native from the start; avoids the retiring ingress-nginx; clear path to the realistic Kong destination.
**Cost:** one planned migration (intended, ties to the Step-2 gateway plan).
**Open:** Kong adoption trigger = when auth-offload/rate-limiting is needed.
