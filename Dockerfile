FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app
COPY pnpm-lock.yaml ./pnpm-lock.yaml
COPY pnpm-workspace.yaml ./pnpm-workspace.yaml

# DEPENDENCIES

FROM base AS install
COPY ui/ /app/ui
COPY jsapi/ /app/jsapi
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM install AS build
RUN pnpm run -r build
# Don't "pnpm deploy" ui because the command above already builds the dist required for nginx
RUN pnpm deploy --filter=jsapi --prod /prod/jsapi

# pnpm dev for subprojects

FROM install AS ui-dev
WORKDIR /app/ui
CMD [ "pnpm", "dev" ]

FROM install AS jsapi-dev
WORKDIR /app/jsapi
CMD [ "pnpm", "dev" ]

# PRODUCTION

## UI

FROM nginx AS ui-prod
COPY --from=build /app/ui/dist /usr/share/nginx/html
RUN mkdir /etc/nginx/templates
COPY ./ui/default.conf.template /etc/nginx/templates

## JS API

FROM base AS jsapi-prod
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /prod/jsapi /app
CMD [ "pnpm", "run", "start" ]