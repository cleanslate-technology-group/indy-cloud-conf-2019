FROM alpine:3.9.3

RUN apk update && apk add bind-tools

CMD ["dig", "+short", "myip.opendns.com", "@resolver1.opendns.com"]
