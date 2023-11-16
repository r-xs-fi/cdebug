FROM --platform=linux/amd64 fn61/buildkit-golang:20230219_1208_a7139a03 AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

# WORKDIR /workspace


# /.config because Croc wants to write some config files and I'm too lazy to set up ENVs in such a way
# that it would point in actual home directory (which we'd have to create also)
RUN cd / && git clone https://github.com/iximiuz/cdebug.git

RUN cd /cdebug && GOARCH=$TARGETARCH CGO_ENABLED=0 go build -ldflags "-extldflags \"-static\""

FROM scratch

ENTRYPOINT ["/usr/bin/cdebug"]

COPY --from=builder /cdebug/cdebug /usr/bin/cdebug

# running as unprivileged user not possible because: intended to be superuser tool
