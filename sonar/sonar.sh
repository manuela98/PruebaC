echo "Running sonar scanner..."
sonardir=sonar
bash $sonardir/coverage.sh
sonar-scanner -Dproject.settings=$sonardir/sonar.conf |tee $sonardir/sonar.log
