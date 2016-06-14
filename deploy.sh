#!/bin/bash

echo "Proběhne deploy produkční verze"
echo $(date)
echo "-------------------------------"
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

echo "2. Proběhne aktualizace tagů a verze aplikace"
git fetch --tags
git describe --tags > ../staging/version
echo ""

cd ..


echo "3. Nastaví se aktuální production jako production-previous"
productionRelease=$(readlink production)
ln -sfnv $productionRelease production-previous
echo ""

echo "4. Nastaví se aktuální staging jako production"
stagingRelease=$(readlink staging)
ln -sfnv $stagingRelease production
echo ""

echo "5. Stav deploye"
printf "staging -> "
readlink staging
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "6. Konec deploye"
echo $(date)
