### Docker Test

Please do **NOT** use this, it's just an example for me to know pnpm + docker + monorepos better.

If you want to know how to use pnpm with docker use this instead: https://pnpm.io/docker#example-2-build-multiple-docker-images-in-a-monorepo


- Dev: `docker compose up --watch`
- Prod: `docker compose -f compose.yml -f compose-production.yml up --build`