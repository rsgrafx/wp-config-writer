pull:
	git pull origin master && mix do deps.get, compile

compile-build:
	mix deps.get && mix compile --force && mix do escript.build, escript.install

build-script:
	mix do escript.build, escript.install

rebuild:
	$(MAKE) pull
	$(MAKE) build-script