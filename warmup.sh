#!/bin/bash

echo ""
echo "Proběhne sestavení WARM-UP prostředí"
echo $(date)
echo "-------------------------------------------"
USED=$(cat ./production/temp/redis)

SELECTED=$1

if [ -z "$1" ]; then
 echo "Vyberte Redis DB. Produkční je ${USED}."
 exit 1
fi

if [ $SELECTED == $USED ]; then
  echo "Vyberte jinou DB, tato se využívá v produkci"
  exit 2
fi

echo ""
echo "1. Stav před deployem"
printf "warmup -> "
readlink warmup
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

cd repository

echo "2. Příprava repozitáře"
echo " - 2.1. vyčištění"
git clean -xdf .
echo ""

echo " - 2.2. aktualizace kódu"
git pull -p
echo ""

latestCommit=$(git log -n1 --format="%h")
deployUser=$(git log -n1 --format="%an")

echo " - 2.3. poslední commit je $latestCommit"
echo ""

echo " - 2.4. export do ./releases/$latestCommit"
git checkout-index -af --prefix=../releases/$latestCommit/
echo $latestCommit | tee ../releases/$latestCommit/temp/commit > /dev/null
echo $deployUser | tee ../releases/$latestCommit/temp/deployUser > /dev/null
echo ""

cd ..

echo "3. Sestavení release"

cd ./releases/$latestCommit

echo " - 3.1. Composer"
make production-composer
echo ""

echo " - 3.2. Assets"
make production-assets
echo ""

echo " - 3.3. Dynamic files, Symlinks"
make production-warmup

echo ""
echo "Redis DB"
redis-cli -n $SELECTED flushdb
sed -i "s/database: [[:digit:]]/database: ${SELECTED}/g" app/config/local.neon
echo $SELECTED | tee temp/redis > /dev/null

echo "4. Databázové migrace"
echo " - 4.1. Stav migrací"
php tools/db-migrate.php status

echo ""

echo " - 4.2. Provádění migrací"
php tools/db-migrate.php up

echo ""
cd ../..

buildError=$?

if [ $buildError -gt 0 ]; then

	echo "5. Sestavení neproběhlo v pořádku, chybový kód je"
	echo $buildError
	echo ""

else

	echo "5. WarmUp se nastaví na poslední release - ./releases/$latestCommit"
	ln -sfn releases/$latestCommit warmup

  echo ""
	cd ./warmup
	make deploy-notify-warmup
	cd ..
	echo ""

fi;

echo "6. Stav po deployi do WARM-UP prostředí"
printf "warmup -> "
readlink warmup
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "7. Odeberou se stará sestavení"
warmupRelease=$(readlink warmup | cut -d / -f 2)
productionRelease=$(readlink production | cut -d / -f 2)
productionPreviousRelease=$(readlink production-previous | cut -d / -f 2)

cd releases
rm -rf `ls -t | grep -v $warmupRelease | grep -v $productionRelease | grep -v $productionPreviousRelease | tail -n +2`
ls -lt .

echo ""

echo "8. Využití disku"
df .
echo ""

echo "9. Konec aktualizace"
echo $(date)
echo $buildError
