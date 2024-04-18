#!/bin/sh

if [ $# -lt 1 ]; then
    echo >&2 "Missing argument"
    exit 1
fi

case "$(basename $1)" in
    kc)  NAME='Kubernetes controller tool' ;;
    km)  NAME='Kubernetes master' ;;
    kw)  NAME='Kubernetes worker' ;;
    klb) NAME='Kubernetes load-balancer' ;;
    *)   NAME='Unknown' ;;
esac

help2man --no-info -n "$NAME" $1
