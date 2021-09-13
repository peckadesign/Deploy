#!/bin/bash

echo ""
echo "Proběhne přepnutí na předchozí release"
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

echo "2. Vypnutí démonů"
supervisorctl status
supervisorctl stop all

echo "3. Nastaví se aktuální production-previous jako production"
previousProduction=$(readlink production-previous)
ln -sfnv $previousProduction production
echo ""

cd ./production || { echo "Adresář production neexistuje"; exit 1; }

make production-supervisor

echo "4. Zapnutí démonů"
supervisorctl reload

cd ..

echo "5. Stav deploye"
printf "warmup -> "
readlink warmup
printf "production -> "
readlink production
printf "production-previous -> "
readlink production-previous
echo ""

echo "6. Konec deploye"
echo $(date)
