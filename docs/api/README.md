# Service Contracts

**Caveman:** the printed order-forms. A contract says exactly what you can ask each service and what comes back — so callers never guess.

- **OpenAPI** files = the *sync* "ask through the window" requests (one per service).
- **AsyncAPI** file = the *async* "announce news" events on the bus.

These are **first-pass contracts** built from the requirements. They cover the main operations; we refine field-by-field as each service is built. They are contract-FIRST on purpose: agree the shape, then build to it, then test against it (great for API testing).
