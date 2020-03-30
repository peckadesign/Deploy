Symlinkový deploy
===

 - Slouží k nasazení nové verze aplikace s bez či s minimálním výpadkem.
 - Aplikace se nejdříve připravý v předprodukčním prostředí a až poté je přepnuto produkční prostředí
 
#### Adresářová struktura

Skutečné složky:
```
    repository => naklonovaný projekt
    releases/<commit-hash> => vyexportovaná aktuální verze projektu z repository
    common => složka s datama a konfigurací, které mají zůstat napříč deployi
```
Symlinky:

```
    warmup => ./release/<commit-hash>
    www_warmup => ./warmup/www

    production => ./release/<commit-hash>
    www => ./production/www
    app => ./production/app # Cesta pro supervisor.conf

    production/log => common/log

    www/data/banners => common/www/data/banners
    www/data/images => common/www/data/images    
```
V rámci WARM-UPu se spouští projektové ```make production-links```, kde lze udělat symlinky _project specific_:

```Makefile
production-links:
	# Now, you are at ./releases/<commit-hash>
	ln -sfn ../../../../../common/www/webs/1/exports ./www/webs/1/exports
	ln -sfn ../../../../../common/www/webs/2/exports ./www/webs/2/exports
	cp ../../common/app-cz/config/local.neon app-cz/config/local.neon
	cp ../../common/app-hu/config/local.neon app-hu/config/local.neon
```

#### Postup deploye

##### Spuštění ```warmup.sh```

1. Provede se ```git pull``` v adresáři ```repository```
2. Vyexportuje ```repository``` do ```releases/<commit-hash>```
3. Spustí projektové ```make production-composer``` a ```make production-assets```
4. Vytvoří symlinky viz. výše
5. DB migrace (zkontroluje stav a případně provede migraci)
6. V tuto chvíli by mělo být připraveno warm-up prostředí a provede se notifikace ```make deploy-notify-warmup```

---
##### Spuštění ```production.sh```

1. Vypnout se démoni ```supervisorctl stop all```
2. Přepnete se symlink a nová verze aplikace je dostupná na produkci
3. Spustí projektové ```make production-supervisor``` - provádí ```rabbitmq:setup-fabric``` atp.
4. Zapnout se démoni ```supervisorctl reload```
5. Notifikace deploye na produkci, projektové volání ```make deploy-notify```

# Profit!