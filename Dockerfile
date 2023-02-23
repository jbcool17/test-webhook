FROM golang:1.19-alpine AS build
RUN apk --no-cache add git
ADD . /src
RUN cd /src && go build -o test-webhook

FROM alpine

WORKDIR /app

COPY --from=build /src/test-webhook /app/
ENTRYPOINT /app/test-webhook
EXPOSE 8443
