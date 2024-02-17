#! make

db:
	Rscript bloodmoon.R

build:
	podman build -t redbean .

up:
	podman run --name bloodmoon -d -p "8080:8080" redbean

browse:
	firefox localhost:8080/

	# uh, this doesn't work unfortunately...
	#./carbonyl.sh http://localhost:8080/

about:
	./carbonyl https://redbean.dev/

request-webshop:
	http :8080/products/316fb6b3-3abb-4bf2-b523-0c2b328d874c | jq

request-apis:
	http :8080/api/products | jq
	http :8080/api/reviews | jq
	http :8080/api/prices | jq

bench:
	podman run --network host --rm docker.io/cylab/wrk2 \
		-R 2000 -L -d 30s -t 4 -c 100 http://localhost:8080/products

clean:
	podman stop bloodmoon
	podman rm -f bloodmoon

