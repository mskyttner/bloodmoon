FROM alpine:latest as build

ARG DOWNLOAD_FILENAME=redbean-2.2.com

RUN apk add --update zip bash
RUN wget https://redbean.dev/${DOWNLOAD_FILENAME} -O redbean.com
RUN chmod +x redbean.com

# normalize the binary to ELF
RUN sh /redbean.com --assimilate

WORKDIR /src/bloodmoon
COPY .init.lua synth.db .
RUN mkdir -p .lua
COPY .lua/fullmoon.lua .lua

RUN zip /redbean.com .init.lua .lua/* synth.db *

CMD ["/redbean.com", "-v", "-p", "8080", "-p", "3000", "-p", "3001", "-p", "3002"]
