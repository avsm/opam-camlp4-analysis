DATE=20130129

.PHONY: clean all

all: stats/$(DATE).summary

table:
	(cd scripts && ./build.sh)
	./scripts/gather.native stats/$(DATE)/

stats/$(DATE).summary: stats/$(DATE)/.stamp
	./scripts/gather-stats.sh logs/$(DATE) stats/$(DATE) 
	rm -f stats/$(DATE)/*.tmp
	cat stats/$(DATE)/* | sort -u > $@

stats/$(DATE)/.stamp: logs/$(DATE)/.stamp
	rm -rf stats/$(DATE)
	mkdir -p stats/$(DATE)
	@touch $@
	
logs/$(DATE)/.stamp:
	cd logs && tar -jxvf $(DATE).tar.bz2
	@touch $@

clean:
	rm -rf logs/$(DATE) stats
