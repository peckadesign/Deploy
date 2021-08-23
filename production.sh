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

productionRelease=$(readlink production)
warmupRelease=$(readlink warmup)

if [ "$productionRelease" == "$warmupRelease" ]; then
  echo "Produkce je již na požadovaném releasu. $productionRelease === $warmupRelease  Ukončuji deploy.";
  exit 1;
fi

echo "2. Nastaví se aktuální production jako production-previous"
ln -sfnv $productionRelease production-previous
echo ""

echo "3. Vypnutí démonů"
supervisorctl status
supervisorctl stop all

echo "4. Nastaví se aktuální warmup jako production"
ln -sfnv $warmupRelease production
echo ""

cd ./production || { echo "Adresář production neexistuje"; exit 1; }

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
