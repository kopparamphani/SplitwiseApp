# ADR-0008 — Apache Kafka as the event bus
**Status:** Accepted
**Date:** 2026-06-19

## Context
ADR-0004 made Balance an event-fed read model. That needs a bus. Kafka is famously overused for simple queues, so the choice had to be justified by a real need, not reflex.

## Decision
**Apache Kafka.** Two reasons tip it over NATS/RabbitMQ: (1) Balance rebuilds from event history, and Kafka's durable, replayable log is purpose-built for that; (2) it's the enterprise standard the user is heading toward.

## Consequences
**Good:** durable replay (Balance's lifeline); enterprise/job-market weight; fits the event-sourcing-flavoured design.
**Cost:** heaviest to operate — but that operational work is exactly the Step-3 Kubernetes learning.
**Open:** none on choice. Disciplines required regardless: dead-letter queues, idempotent consumers, schema registry (AsyncAPI groundwork already laid).
**Alternative on file:** NATS + JetStream if we later prioritise lighter ops over enterprise mileage.
