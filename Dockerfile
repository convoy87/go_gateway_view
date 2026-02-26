# 第一步：构建前端项目（基于Node镜像）
FROM node:18-alpine as build-stage
WORKDIR /app
# 复制依赖文件，利用Docker缓存加速构建
COPY package*.json ./
RUN npm install --registry=https://registry.npmmirror.com  # 国内源，安装更快
# 复制所有项目文件
COPY . .
# 执行构建命令（根据你的项目调整，Vue是npm run build，React是npm run build）
RUN npm run build

# 第二步：生产环境（基于Nginx镜像，运行静态文件）
FROM nginx:alpine as production-stage
# 把构建好的dist目录复制到Nginx的默认静态文件目录
COPY --from=build-stage /app/dist /usr/share/nginx/html
# 暴露80端口（与容器启动时的端口映射对应）
EXPOSE 80
# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]
