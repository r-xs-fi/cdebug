FROM --platform=linux/amd64 fn61/buildkit-golang:20241119_1422_525a63d3 AS builder

# can't have default values here, otherwise they'd overwrite the buildx-supplied ones
ARG TARGETOS
ARG TARGETARCH

# WORKDIR /workspace


# /.config because Croc wants to write some config files and I'm too lazy to set up ENVs in such a way
# that it would point in actual home directory (which we'd have to create also)
RUN cd / && git clone https://github.com/iximiuz/cdebug.git

RUN cd /cdebug && GOARCH=$TARGETARCH CGO_ENABLED=0 go build -ldflags "-extldflags \"-static\""

FROM scratch

ENTRYPOINT ["/usr/bin/cdebug"]

COPY --from=builder /cdebug/cdebug /usr/bin/cdebug

# running as unprivileged user not possible because: intended to be superuser tool
