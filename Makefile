.PHONY: run s1 s2 s3

s1:
	NODES="count2@127.0.0.1,count3@127.0.0.1" iex --name count1@127.0.0.1 --cookie secret -S mix
s2:
	ERL_FLAGS="-name count2@127.0.0.1 -setcookie cookie"
	NODES="count1@127.0.0.1,count3@127.0.0.1" iex --name count2@127.0.0.1 --cookie secret -S mix

s3:
	ERL_FLAGS="-name count3@127.0.0.1 -setcookie cookie"
	NODES="count1@127.0.0.1,count2@127.0.0.1" iex --name count3@127.0.0.1 --cookie secret -S mix

build:
	docker build -t ex_cluster:local .