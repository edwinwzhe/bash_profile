### PyCharm
export GEVENT_SUPPORT=True

# VirtualEnv
if [[  $VENV_DIR == ""  ]]; then
    echo "Set VENV_DIR for Python virtualenv aliases"
else
    for venv_path in ${VENV_DIR}/*; do
        venv_name=`echo $venv_path | rev | cut -d/ -f1 | rev`
        alias activate_${venv_name}="source ${venv_path}/bin/activate"
    done
fi
