#!/bin/bash

echo ""
echo "Proběhne přepnutí produkčního prostředí"
echo $(date)
echo "-------------------------------------------"
echo ""

echo "1. Stav před deployem"
printf "warmup -> "
readlink warmup
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "2. Nastaví se aktuální production jako production-previous"
productionRelease=$(readlink production)
ln -sfnv $productionRelease production-previous
echo ""

echo "3. Vypnutí démonů"
supervisorctl status
supervisorctl stop all

echo "4. Nastaví se aktuální warmup jako production"
warmupRelease=$(readlink warmup)
ln -sfnv $warmupRelease production
echo ""

cd ./production

make production-supervisor

echo "5. Zapnutí démonů"
supervisorctl reload

make deploy-notify
cd ..

echo "6. Stav deploye"
printf "warmup -> "
readlink warmup
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "6. Konec deploye"
echo $(date)
