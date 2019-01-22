get_container_id(){
    if [[ $# -ne 1 ]];then
        echo "Container name not given!"
        return
    fi

    name=$1
    #container_id=`docker ps | egrep "[\s/]${name}:" | awk '{print $1}'`

    if [[ `docker ps -a 2>/dev/null | egrep "_${name}_" | wc -l` -eq 1 ]]; then
        # search _name_
        container_name=`docker ps -a 2>/dev/null | egrep "_${name}_" | awk '{print $NF}'`
    elif [[ `docker ps -a 2>/dev/null | egrep "\/${name}:" | wc -l` -eq 1 ]]; then
        # search /name:
        container_name=`docker ps -a 2>/dev/null | egrep "\/${name}:" | awk '{print $NF}'`
    else
        # search name
        if [[ `docker ps -a 2>/dev/null | egrep "${name}" | wc -l` -eq 1 ]]; then
            container_name=`docker ps -a 2>/dev/null | egrep "${name}" | awk '{print $NF}'`
        elif [[ `docker ps -a 2>/dev/null | egrep "${name}" | wc -l` -gt 1 ]]; then
            >&2 echo "More than one container found: "
            docker ps -a | egrep "${name}"
            return 1
        else
            return 1
        fi
    fi

    >&2 echo "Container name found: ${container_name}"
    #container_name=`docker ps -a 2>/dev/null | egrep "${name}" | awk '{print $NF}'`
    container_id=`docker inspect --format='{{.Id}}' ${container_name} 2>/dev/null`

    # echo "Found container $container_name ($container_id)"
    echo "${container_id}"
    return 0
}

start_container(){
    container_id=`get_container_id $1`

    if [[ $? -ne 0 ]]; then
        >&2 echo "Failed to get container id..."
    else
        docker start $container_id
    fi
}

stop_container(){
    container_id=`get_container_id $1`

    if [[ $? -ne 0 ]]; then
        >&2 echo "Failed to get container id..."
    else
        docker stop $container_id
    fi
}

get_container_ip(){
    container_id=`get_container_id $1`

    if [[ $? -ne 0 ]]; then
        >&2 echo "Failed to get container id..."
        return 1
    fi

    container_ip=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id 2>/dev/null`
    echo $container_ip
    return 0
}

get_into_docker_container(){
    name=$1

    container_id=`get_container_id ${name}`

    if [[ $? -ne 0 ]];then
        >&2 echo "Container $name not found!"
        return 1
    fi 

    >&2 echo "Getting into container $name with id: $container_id"

    docker exec -it $container_id bash
}

get_container_log(){
    name=$1

    container_id=`get_container_id ${name}`

    if [[ $? -ne 0 ]]; then
        >&2 echo "Container $name not found!"
        return 1
    fi

    log_count=`docker exec logrotate bash -c "ls -1 /var/lib/docker/containers/${container_id}/*json.log*" 2>/dev/null | wc -l`

    if [[ $log_count -eq 0 ]]; then
        >&2 echo "No log found for container..."
        return 1
    elif [[ $log_count -eq 1 ]]; then
        log_file=`docker exec logrotate bash -c "ls -1 /var/lib/docker/containers/${container_id}/*json.log*" 2>/dev/null`

        timestamp=`docker exec logrotate bash -c "stat -c '%y %n' $log_file" 2>/dev/null | cut -c1-19 | sed 's/\s/_/g'`
        save_as_file="${name}.`echo ${container_id} | cut -c1-12`.${timestamp}"

        >&2 echo "Getting log file $log_file from logrotate as /tmp/${save_as_file}.json.log"
        docker cp logrotate:${log_file} /tmp/${save_as_file} #2>/dev/null

        if [[ -e /tmp/${save_as_file} ]]; then
            if [[ `file /tmp/${save_as_file} | grep compressed | wc -l` -eq 1 ]]; then
                zcat /tmp/${save_as_file} > /tmp/${save_as_file}.json.log
            else
                mv /tmp/${save_as_file} /tmp/${save_as_file}.json.log
            fi

            python ~/margarita_tools/parse_json_service_log.py /tmp/${save_as_file}.json.log | less
        fi
        return 0
    fi

    # More than one log file
    temp=`mktemp`
    docker exec logrotate bash -c "stat -c '%y %n' /var/lib/docker/containers/${container_id}/*json.log*" 2>/dev/null > $temp

    >&2 echo "Choose one from below..."
    log_id=1
    while read log
    do
        printf " (${log_id}) "
        echo $log | sed "s/${container_id}/<id>/g"
        (( log_id = log_id + 1 ))
    done < $temp

    read choice

    if [[ $choice -lt 1 || $choice -ge $log_id ]]; then
        >&2 echo "$choice out of range..."
        return 1
    fi

    log_file=`cat $temp | head -${choice} | tail -1 | awk '{print $NF}'`
    timestamp=`cat $temp | head -${choice} | tail -1 | cut -c1-19 | sed 's/\s/_/g'`
    save_as_file="${name}.`echo ${container_id} | cut -c1-12`.${timestamp}"

    >&2 echo "Getting log file $log_file from logrotate as /tmp/${save_as_file}.json.log"
    docker cp logrotate:${log_file} /tmp/${save_as_file} #2>/dev/null

    echo docker cp logrotate:${log_file} /tmp/${save_as_file}
    if [[ `file /tmp/${save_as_file} | grep compressed | wc -l` -eq 1 ]]; then
        zcat /tmp/${save_as_file} > /tmp/${save_as_file}.json.log
    else
        mv /tmp/${save_as_file} /tmp/${save_as_file}.json.log
    fi

    python ~/margarita_tools/parse_json_service_log.py /tmp/${save_as_file}.json.log | less
    return 0
}

dc_reload() {
    docker-compose stop $1
    docker-compose up --force-recreate -d $1
}

dc_reload_and_log() {
    docker-compose stop $1
    dcup_and_log $1
}

dcup_and_log() {
    docker-compose up --force-recreate -d $1
    docker-compose logs -f $1
}

dcrestart_and_log() {
    docker-compose restart $1
    docker-compose logs -f $1
}



# Docker container alias
alias goto='get_into_docker_container'
alias ip='get_container_ip'
alias log='get_container_log'

# Docker compose alias
alias dps='docker ps'
alias dlogs='docker logs'
alias dstop='stop_container'
alias dstart='start_container'

# Docker compose alias
alias dcps='docker-compose ps'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcstop='docker-compose stop'
alias dclogs='docker-compose logs'
alias dcre='docker-compose restart'
alias dcreload='dc_reload'
alias dcuplogs='dcup_and_log'
alias dcrelogs='dcrestart_and_log'
alias dcreloadlogs='dc_reload_and_log'

# Docker util alias
alias docker_rm_containers="docker container rm $(docker container ls -aq)"
