# bloodmoon

This repo is a test using the redbean application server with the "fullmoon" framework for lua-based web applications. Learn more about [redbean, the cosmopolitan libc-based redbean application server](https://justine.lol/redbean2/). This seems to offer good performance according to these benchmarks:

- https://github.com/pkulchenko/fullmoon?tab=readme-ov-file#benchmark
- https://github.com/berwynhoyt/lua-server-benchmark?tab=readme-ov-file

![](https://camo.githubusercontent.com/5621aafffc43ac4e7497fc128f51ffa24f0b28d919c8a69605c5b9212070e9fe/68747470733a2f2f646f63732e676f6f676c652e636f6d2f7370726561647368656574732f642f652f32504143582d3176526b31387a59584830597678364b4b57714f3059706b6564666730364739396e6656356c38754d56516338735f687853314e3834765865747369514539533674655533506f495977506a565248552f70756263686172743f6f69643d37393531303633363126666f726d61743d696d616765)

It is a simple test trying out the "fullmoon" lua web framework with a dynamic database with three tables/entities - products, reviews and prices. The solution is packaged as a container and the application provides some routes / API endpoints for those entities (a "backend") and a very very simplistic "frontend" part capable of providing a product listing and some product details (json).

## Usage

Synthetic data for products, reviews and prices (10 000 of each) was generated using:

        make db

This uses an R script which synthesizes data based on some .json files provided in the repo. The result is the `synth.db`sqlite3 database.

When doing `make build`, this database is embedded and used from within the redbean web server which also includes an application utilizing the fullmoon.lua web framework, with the (simplistic!) application code in `.init.lua`.

To run and benchmark the service, use the `Makefile`:

        # build a container, 24.6 MB including everything (redbean, fullmoon, application, database)
        make build

        # start it locally, exposing it on port 8080
        make up

        # check it out in the browser
        make browse

        # issue some requests against the "backend" / API endpoints
        make request-apis

        # issue some requests against the "frontend"
        make request-webshop

        # run a benchmark
        make bench

        # clean up
        make clean

The `Makefile` makes use of `podman` and `httpie` (see [httpie](https://httpie.io/)) and wrk2 (containerized, but see [GitHub repo here](https://github.com/giltene/wrk2)).
