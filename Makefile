pull:
	git pull origin master 

compile:
	mix deps.get && mix compile --force

script:
	mix do escript.build, escript.install

rebuild-dev:
	$(MAKE) compile
	$(MAKE) script

rebuild:
	$(MAKE) pull
	$(MAKE) compile
	$(MAKE) script