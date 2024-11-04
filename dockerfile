# Etapa 1: Construção
FROM node:18-alpine AS builder

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie os arquivos de dependências
COPY package*.json ./

# Instale as dependências
RUN npm install

# Copie todo o código do projeto para o contêiner
COPY . .

# Execute o build da aplicação
RUN npm run build

# Etapa 2: Servidor de Produção
FROM nginx:alpine

# Remova a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copie sua configuração personalizada do Nginx (opcional)
# COPY nginx.conf /etc/nginx/conf.d

# Copie os arquivos estáticos da etapa de construção
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponha a porta 80
EXPOSE 80

# Inicie o Nginx
CMD ["nginx", "-g", "daemon off;"]