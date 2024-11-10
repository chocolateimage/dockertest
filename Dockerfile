FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app
COPY pnpm-lock.yaml ./pnpm-lock.yaml
COPY pnpm-workspace.yaml ./pnpm-workspace.yaml
COPY ui/ ./ui
COPY jsapi/ ./jsapi

# DEPENDENCIES

FROM base AS deps-prod
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS deps-dev
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

# pnpm dev for subprojects

FROM deps-dev AS dev-ui
WORKDIR /app/ui
CMD [ "pnpm", "dev" ]

FROM deps-dev AS dev-jsapi
WORKDIR /app/jsapi
CMD [ "pnpm", "dev" ]

# PRODUCTION

## UI

FROM deps-dev AS build-ui
WORKDIR /app/ui
RUN pnpm run build

FROM nginx AS prod-ui
WORKDIR /app/ui
COPY --from=build-ui /app/ui/dist /usr/share/nginx/html
RUN mkdir /etc/nginx/templates
COPY ./ui/default.conf.template /etc/nginx/templates

## JS API

FROM base AS prod-jsapi
WORKDIR /app/jsapi
COPY --from=deps-prod /app/node_modules /app/node_modules
COPY --from=deps-prod /app/jsapi/node_modules /app/jsapi/node_modules
CMD [ "pnpm", "run", "start" ]