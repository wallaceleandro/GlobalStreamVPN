#!/data/data/com.termux/files/usr/bin/bash

echo "======================================"
echo "CORRIGINDO JVM TARGET DO KOTLIN"
echo "======================================"

PROJECT=~/GlobalStreamVPN

cd $PROJECT || exit

echo "Procurando JVM 21 no projeto..."

grep -r "21" .

echo "--------------------------------------"
echo "Substituindo JVM 21 por JVM 17"
echo "--------------------------------------"

find . -type f -name "*.gradle" -exec sed -i 's/jvmTarget = "21"/jvmTarget = "17"/g' {} \;
find . -type f -name "*.gradle" -exec sed -i 's/jvmTarget="21"/jvmTarget="17"/g' {} \;

find . -type f -name "*.gradle.kts" -exec sed -i 's/jvmTarget = "21"/jvmTarget = "17"/g' {} \;
find . -type f -name "*.gradle.kts" -exec sed -i 's/jvmTarget="21"/jvmTarget="17"/g' {} \;

find . -type f -name "*.properties" -exec sed -i 's/21/17/g' {} \;

echo "--------------------------------------"
echo "Limpando build novamente"
echo "--------------------------------------"

./gradlew clean

echo "--------------------------------------"
echo "Compilando novamente"
echo "--------------------------------------"

./gradlew assembleDebug

echo "======================================"
echo "CORREÇÃO FINALIZADA"
echo "======================================"

echo "Se tudo deu certo o APK estará em:"
echo "app/build/outputs/apk/debug/app-debug.apk"
