
USENAME=andyneff

all:
	docker build -t $(USERNAME)/gpg_agent .

install:
	docker push $(USERNAME)/gpg_agent