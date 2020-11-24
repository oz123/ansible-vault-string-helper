PREFIX ?= /usr/local
PROG ?= ansible-vault-string.sh

install::
	install -m 755 -g root -o root $(PROG) $(PREFIX)/bin/

uninstall::
	rm $(PREFIX)/bin/$(PROG)

test:
	./test.sh ./$(PROG)
