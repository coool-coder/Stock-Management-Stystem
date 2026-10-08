# Architecture

The application uses a modular monolith initially. Features are separated by business capability so the system can later be extracted into services if scale requires it.

## Core principle

`inventory` stores the current balance. `stock_movements` is the audit/history ledger. Every operation that changes stock must update both inside one database transaction.

## Layers

- Controller: HTTP/API contract
- Service: business rules and transaction boundaries
- Repository: persistence
- DTO: API input/output models
- Entity: database model
- Security: authentication and authorization
- Exception: consistent error handling

## Important invariant

For a product in a warehouse:

`available = on_hand_quantity - reserved_quantity`

Stock-changing operations must be transactional and must protect against concurrent overselling.
