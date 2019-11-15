#!/bin/bash

kubectl get nodes -o go-template='{{range $item := .items}}{{with $nodename := $item.metadata.name}}{{range $taint := $item.spec.taints}}{{if and (eq $taint.key "node-role.kubernetes.io/master") (eq $taint.effect "NoSchedule")}}{{printf "%s\n" $nodename}}{{end}}{{end}}{{end}}{{end}}'
