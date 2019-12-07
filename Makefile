pull:
	git pull origin master && mix do deps.get, compile

compile-build:
	mix compile --force && mix escript.build

build-script:
	mix escript.build

rebuild:
	$(MAKE) pull
	$(MAKE) build-script