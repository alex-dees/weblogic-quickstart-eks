helm repo add traefik https://helm.traefik.io/traefik --force-update
helm pull traefik/traefik --untar --untardir assets

helm repo add weblogic-operator \
https://oracle.github.io/weblogic-kubernetes-operator/charts \
--force-update
helm pull weblogic-operator/weblogic-operator --untar --untardir assets



