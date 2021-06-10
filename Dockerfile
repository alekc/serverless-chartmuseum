FROM docker.io/alekcander/al2-go as build
RUN go env -w GOPROXY=direct

# cache dependencies
ADD go.mod go.sum ./
RUN go mod download

# build
ADD . .
RUN cd src && go build -o /main

# copy artifacts to a clean image
FROM public.ecr.aws/lambda/provided:al2
COPY --from=build /main /main
ENTRYPOINT [ "/main" ]
