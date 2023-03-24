# MongoDB副本集Docker开发环境(compose版本)
---
该项目本地以Compose方式部署开发环境所使用的模板

## 准备工作
### 1. 编辑`.env-dist`(非必须)
如果本地使用了多套该compose运行环境，则必须调整各自目录下该文件的`COMPOSE_PROJECT_NAME`参数值，以确保相互间唯一

### 2. 创建`docker-compose.yml`
#### 2.1 从模板文件复制生成`docker-compose.yml`
```bash
cp docker-compose.yml.template docker-compose.yml
```
#### 2.2 内容调整
替换相关访问账户与密码

### 3. 生成副本集认证key文件
```
// 宿主机自行安装openssl
openssl rand -base64 768 > ./mongo/security/key
```

---

## 常用命令
### Build
`make build`

### Start
`make start`

### Stop
`make stop`

### Status
`make status`

### Down
`make down`

---

## 其他
### 构建副本集
1. 进入primary容器
```
docker exec -it [PRIMARY_1_CONTAINER] bash
# 连接当前服务
mongosh -u [user] -p [pass]
```

2. 配置副本集
```
rs.initiate(
  {
    _id : 'rs0',
    members: [
      { _id : 0, host : "[本机IP]:27017", priority: 2 },
      { _id : 1, host : "[本机IP]:27018", priority: 1 },
      { _id : 2, host : "[本机IP]:27019", priority: 1, arbiterOnly: true }
    ]
  }
)

# 查看副本集状态
rs.status()
```

### 连接副本集
```
docker run --rm -it mongo bash

# 访问单个节点
# mongosh --host [IP:port] -u [user] -p [pass] --authenticationDatabase admin [db]

# 访问副本集服务
mongosh "mongodb://[访问账户]:[访问密码]@[本机IP]:27017,[本机IP]:27018,[本机IP]:27019/?replicaSet=rs0"
```

### 额外说明
考虑到可用性和服务器资源有限，集群里设置了三个节点，一主一副和一个投票节点(仅参与投票，不保存业务数据)

> 该compose模板支持不同需求下开发环境的扩展，但仅限于在本地进行软件开发测试场景使用，不推荐在实际的生产环境下部署使用
