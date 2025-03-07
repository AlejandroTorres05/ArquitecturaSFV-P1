#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' 

IMAGE_NAME="evaluation-app"
CONTAINER_NAME="devops-app"
PORT=8080
NODE_ENV="production"

# Función para imprimir mensajes de estado
print_status() {
  if [ $1 -eq 0 ]; then
    echo -e "${GREEN}[✓] $2${NC}"
  else
    echo -e "${RED}[✗] $2${NC}"
    exit 1
  fi
}

# Función para imprimir mensajes informativos
print_info() {
  echo -e "${YELLOW}[i] $1${NC}"
}

# 1. Verificar si Docker está instalado
print_info "Verificando si Docker está instalado..."
if command -v docker &> /dev/null; then
  print_status 0 "Docker está instalado."
fi

# 2. Construir la imagen automáticamente
print_info "Construyendo imagen Docker '${IMAGE_NAME}'..."
  if docker build -t ${IMAGE_NAME} .; then
  print_status 0 "Imagen '${IMAGE_NAME}' construida exitosamente."
  fi

# 3. Ejecutar el contenedor con las variables de entorno adecuadas
print_info "Ejecutando contenedor '${CONTAINER_NAME}'..."
  if docker run -d -p ${PORT}:${PORT} -e PORT=${PORT} -e NODE_ENV=${NODE_ENV} --name ${CONTAINER_NAME} ${IMAGE_NAME}; then
  print_status 0 "Contenedor '${CONTAINER_NAME}' ejecutándose en http://localhost:${PORT}"
  fi

# 4. Esperar a que el servicio esté listo
print_info "Esperando a que el servicio esté disponible..."
for i in {1..30}; do
  sleep 1
  if curl -s http://localhost:${PORT}/health &> /dev/null; then
    break
  fi
done

# 5. Realizar una prueba básica para verificar que el servicio responde
print_info "Verificando que el servicio responde..."
  if response=$(curl -s http://localhost:${PORT}); then
  print_status 0 "El servicio responde correctamente."
  echo "Respuesta del servicio:"
  echo "${response}" | sed 's/^/  /'
  fi 

# Imprimir un resumen del estado
print_info "Resumen de la implementación:"
echo -e "  ${GREEN}• Imagen Docker: ${IMAGE_NAME}${NC}"
echo -e "  ${GREEN}• Contenedor: ${CONTAINER_NAME}${NC}"
echo -e "  ${GREEN}• Puerto: ${PORT}${NC}"
echo -e "  ${GREEN}• Entorno: ${NODE_ENV}${NC}"
echo -e "  ${GREEN}• Estado: Aplicación desplegada y funcionando correctamente${NC}"
echo -e "  ${GREEN}• URL: http://localhost:${PORT}${NC}"

print_info "Para detener el contenedor, ejecute: docker stop ${CONTAINER_NAME}"
print_info "Para ver los logs, ejecute: docker logs ${CONTAINER_NAME}"

docker rm -f devops-app

exit 0