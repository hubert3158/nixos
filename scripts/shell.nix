{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.maven
    pkgs.sonar-scanner
  ];

  SONARQUBE_HOST_URL = "http://localhost:9000";
  SONARQUBE_LOGIN = "sqp_fd11544b1337f431cb81656830999136be5e36df";
  SONARQUBE_PROJECT_KEY = "influx-mca-web";
  SONARQUBE_PROJECT_NAME = "influx-mca-web";
  SONARQUBE_SOURCES = "launch/src/main/java";
  SONARQUBE_SOURCE_ENCODING = "UTF-8";
}

