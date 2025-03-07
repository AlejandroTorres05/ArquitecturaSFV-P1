# ArquitecturaSFV-P1

# Evaluación Práctica - Ingeniería de Software V

## Información del Estudiante
- **Nombre:** Alejandro Torres Soto
- **Código:** A00394983
- **Fecha:** 7/Marzo/2025

## Resumen de la Solución
La solución implementada consiste en la contenerización de una aplicación Node.js usando Docker y la automatización de su despliegue mediante un script bash. La aplicación es una API REST simple que proporciona información sobre el entorno en el que se ejecuta y un endpoint de verificación de salud. El proceso de despliegue está completamente automatizado, desde la verificación de requisitos hasta las pruebas de funcionamiento.

## Dockerfile
El Dockerfile se ha diseñado siguiendo las mejores prácticas para aplicaciones Node.js:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY app.js ./
EXPOSE 8080
ENV PORT=8080
ENV NODE_ENV=development
CMD ["npm", "start"]
```

Decisiones tomadas:
- **Imagen base ligera:** Seleccioné `node:18-alpine` para minimizar el tamaño de la imagen, ya que Alpine Linux es significativamente más pequeño que otras distribuciones.
- **Optimización de capas:** Seguí el patrón de copiar primero los archivos de dependencias y luego instalarlas, antes de copiar el código fuente. Esto aprovecha la caché de Docker y acelera las reconstrucciones.
- **Instalación de producción:** Utilicé la flag `--production` con npm install para evitar la instalación de dependencias de desarrollo innecesarias.
- **Variables de entorno por defecto:** Configuré valores predeterminados para las variables PORT y NODE_ENV, manteniendo la flexibilidad para sobrescribirlas al ejecutar el contenedor.
- **Exposición de puertos:** Documenté que el contenedor escucha en el puerto 8080 mediante la instrucción EXPOSE.

## Script de Automatización
El script de automatización (`deploy.sh`) se encarga de todo el proceso de despliegue, desde la verificación de requisitos hasta las pruebas de funcionamiento. Las principales funcionalidades son:

1. **Verificación de requisitos:** Comprueba si Docker está instalado y en ejecución.
2. **Limpieza previa:** Elimina contenedores existentes con el mismo nombre para evitar conflictos.
3. **Construcción de imagen:** Construye la imagen Docker a partir del Dockerfile.
4. **Despliegue del contenedor:** Ejecuta el contenedor con las variables de entorno especificadas (PORT=8080 y NODE_ENV=production).
5. **Pruebas de funcionamiento:** Verifica que el servicio esté respondiendo correctamente.
6. **Resumen del estado:** Muestra un resumen detallado del despliegue, incluyendo información útil y comandos adicionales.

## Principios DevOps Aplicados
1. **Automatización:** Toda la solución se basa en la automatización del proceso de despliegue, eliminando la necesidad de intervención manual y reduciendo la posibilidad de errores humanos.
2. **Infraestructura como Código (IaC):** El Dockerfile y el script de despliegue definen la infraestructura de manera declarativa, permitiendo reproducir el entorno de manera consistente.
3. **Integración Continua:** El script de automatización puede integrarse fácilmente en un pipeline CI/CD para automatizar el proceso de construcción y despliegue.

## Captura de Pantalla

En la carpeta resources están todas las capturas que demuestran y sustentan el paso a paso de esta practica

## Mejoras Futuras
1. **Incorporación de tests automatizados:** Integrar pruebas automatizadas en el script de despliegue para verificar la funcionalidad de la aplicación más allá de un simple check de disponibilidad.

2. **Configuración de CI/CD:** Implementar un pipeline completo de CI/CD usando GitHub Actions o Jenkins para automatizar las pruebas, construcción y despliegue de la aplicación.

## Instrucciones para Ejecutar
Para ejecutar la solución, sigue estos pasos:

**Ejecución manual:**
   - Construir la imagen: `docker build -t devops-evaluation-app .`
   - Ejecutar el contenedor: `docker run -p 8080:8080 -e PORT=8080 -e NODE_ENV=production --name devops-app devops-evaluation-app`
   - Verificar funcionamiento: `curl http://localhost:8080`

**Ejecución automatizada:**
   - Dar permisos de ejecución al script: `chmod +x deploy.sh`
   - Ejecutar el script: `./deploy.sh`
