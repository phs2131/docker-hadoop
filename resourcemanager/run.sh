#!/bin/bash

function wait_for_it()
{
        local retry_seconds=5
        local max_try=100
        let i=1

        result=$(hdfs dfsadmin -safemode get)
        array=($result)

        until [ ${array[3]} = 'OFF' ]; do
                echo "[$i/$max_try] check for Namenode SafeMode Status ..."
                echo "[$i/$max_try] $result"
                if (( $i == $max_try )); then
                        echo "[$i/$max_try] $result; giving up after ${max_try} tries. :/"
                        exit 1
                fi

                echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
                let "i++"
                sleep $retry_seconds

                result=$(hdfs dfsadmin -safemode get)
                array=($result)
        done
        echo "[$i/$max_try] $result."
}

wait_for_it ${i}

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
