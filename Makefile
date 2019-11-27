pull:
	git pull origin master && mix do deps.get, compile

build-script:	
	mix escript.build

rebuild:
	$(MAKE) pull
	$(MAKE) build-script