DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)

build:
	docker build -t nicholas/hadoop-base:$(current_branch) ./base
	docker build -t nicholas/hadoop-namenode:$(current_branch) ./namenode
	docker build -t nicholas/hadoop-datanode:$(current_branch) ./datanode
	docker build -t nicholas/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t nicholas/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t nicholas/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t nicholas/hadoop-submit:$(current_branch) ./submit

clean:
	docker rmi nicholas/hadoop-base:$(current_branch)
	docker rmi nicholas/hadoop-namenode:$(current_branch)
	docker rmi nicholas/hadoop-datanode:$(current_branch)
	docker rmi nicholas/hadoop-resourcemanager:$(current_branch)
	docker rmi nicholas/hadoop-nodemanager:$(current_branch)
	docker rmi nicholas/hadoop-historyserver:$(current_branch)
	docker rmi nicholas/hadoop-submit:$(current_branch)

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.2/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) hdfs dfs -rm -r /input

hadoop:
	docker run -it --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} nicholas/hadoop-base:$(current_branch) /bin/bash
