# Stock Management System

A generic, multi-warehouse stock management system designed for different product types and built with React/TypeScript/Tailwind CSS and Spring Boot/PostgreSQL.

## Current phase

**Phase 1 — Foundation**

Included:
- React + TypeScript + Vite + Tailwind CSS frontend skeleton
- Spring Boot + Maven backend skeleton
- PostgreSQL via Docker Compose
- Flyway initial database migration
- Core users/roles/permissions tables
- Product/category/brand/unit tables
- Warehouse/inventory tables
- Stock movement ledger
- Environment variable configuration
- Swagger dependency

Authentication endpoints and JWT implementation are the next step in Phase 1.

## Run PostgreSQL

```bash
docker compose up -d postgres
```

## Run backend

```bash
cd backend
mvn spring-boot:run
```

Backend: http://localhost:8080
Swagger UI: http://localhost:8080/swagger-ui.html

## Run frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend: http://localhost:5173

## Architecture

```text
React + TypeScript + Tailwind
          |
       REST API
          |
Spring Boot / Security / Validation
          |
       JPA/Hibernate
          |
       PostgreSQL
```

## Development order

1. Foundation + authentication
2. Product core
3. Warehouses + inventory
4. Purchasing + receiving
5. Sales + returns
6. Transfers + adjustments + stock counts
7. Reports + dashboard
8. Administration + audit
9. Testing, performance and deployment
