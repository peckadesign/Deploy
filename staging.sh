#!/bin/bash

echo "Proběhne aktualizace stagingového prostředí"
echo $(date)
echo "-------------------------------------------"
echo ""

cd ..

echo "0. Aktuální adresář je"
pwd
echo ""

echo "1. Stav deploye"
printf "staging -> "
readlink staging
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

cd repository

echo "2. Proběhne vyčištění repozitáře"
git clean -xdf .
echo ""

echo "3. Proběhne aktualizace kódu"
git pull -p
echo ""

echo "4. Poslední commit je"
latestCommit=$(git log -n1 --format="%h")
echo $latestCommit
echo ""

echo "5. Proběhne export releasu"
git checkout-index -af --prefix=../releases/$latestCommit/
git describe --tags > ../releases/$latestCommit/version
ls -lt ../releases
echo ""

cd ..

echo "6. Sestaví se poslední release"

ln -sfv ../../../../common/local.neon releases/$latestCommit/app/config/local.neon

cd releases/$latestCommit

export COMPOSER_HOME=/home/pecka && make production

buildError=$?

cd ../..
echo ""

if [ $buildError -gt 0 ]; then

	echo "7. Sestavení neproběhlo v pořádku, chybový kód je"
	echo $buildError
	echo ""

else

	echo "7. Staging se nastaví na poslední release"
	ln -sfnv releases/$latestCommit staging
	echo ""

fi;

echo "8. Stav deploye"
printf "staging -> "
readlink staging
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "9. Odeberou se stará sestavení"
stagingRelease=$(readlink staging | cut -d / -f 2)
productionRelease=$(readlink production | cut -d / -f 2)
productionPreviousRelease=$(readlink production-previous | cut -d / -f 2)
cd releases
rm -r `ls -t | grep -v $stagingRelease | grep -v $productionRelease | grep -v $productionPreviousRelease | tail -n +2`
ls -lt .
echo ""

echo "10. Využití disku"
df .
echo ""

echo "11. Konec aktualizace"
echo $(date)
