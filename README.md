# Shared Infra (Phase: Before CI/CD)

This folder contains shared runtime infrastructure for local development, based on the project specification.

## Included in shared infra

- PostgreSQL (shared instance, multiple databases)
- Redis
- RabbitMQ (+ management UI)
- MongoDB
- Discovery Service (Eureka Server)
- API Gateway

## Files

- `docker-compose.yml`: shared infrastructure (datastores + discovery + gateway)
- `docker-compose.services.yml`: all business services (auth, user, catalog, cart, order, ai, notification)
- `.env.example`: sample environment values
- `docker/spring-boot-service.Dockerfile`: generic Spring Boot image build file
- `docker/postgres/init-multiple-databases.sh`: auto-create service databases on first start

> Note: The current setup is intentionally consolidated into 2 files for development simplicity.
> Later, it should be split again by domain/runtime concerns (for example apps/event/ai overlays).

## Quick Start

1. Copy env file:

```powershell
Copy-Item .env.example .env
```

2. Run core shared infra:

```powershell
docker compose -f docker-compose.yml up -d --build
```

3. Run all services:

```powershell
docker compose -f docker-compose.yml -f docker-compose.services.yml up -d --build
```

4. Stop everything:

```powershell
docker compose -f docker-compose.yml -f docker-compose.services.yml down
```

5. Rebuild + recreate riêng gateway:
docker compose -f docker-compose.yml up -d --build api-gateway

6. Nếu chỉ đổi env/compose config của gateway:
docker compose -f docker-compose.yml up -d --force-recreate api-gateway

## Endpoints

- Eureka: `http://localhost:8761`
- API Gateway: `http://localhost:8080`
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`
- RabbitMQ Management: `http://localhost:15672`
- MongoDB: `localhost:27017`

## Notes

- Gateway runs with `SPRING_PROFILES_ACTIVE=docker` in compose and uses direct container-to-container routes.
- Use only `docker-compose.yml` when you need infra-only development.
- Add `docker-compose.services.yml` when you need to run the full app stack.
- Some services are still scaffold-level and may require additional service-level config/dependencies before fully booting in containers.
