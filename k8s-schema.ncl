let { NameArray, SplitArrayStr, StrLength, .. } = import "utils.ncl" in

{
    ObjectMeta = {
        name | Str | optional,
        labels | {_:Str} | optional,
    },
    ServicePort = {
        name | Str,
        port | Num,
    },
    ServiceSpec = {
        ports | NameArray ServicePort,
        clusterIP | Str | optional,
        selector | {_:Str},
    }, 
    Service = {
        apiVersion = "v1",
        kind = "Service",
        metadata | ObjectMeta,
        spec | ServiceSpec,
    },
    LabelSelector = {
        matchLabels | {_:Str},
    },
    EnvVar = {
        name | Str,
        value | Str,
    },
    VolumeMount = {
        name | Str,
        mountPath | Str,
    },
    ContainerPort = {
        name | Str | StrLength 1 15,
        containerPort | Num,
    },
    Container = {
        name | Str,
        image | Str,
        args | SplitArrayStr,
        env | NameArray EnvVar | optional,
        volumeMounts | NameArray VolumeMount,
        ports | NameArray ContainerPort | optional,
    },
    EmptyDirVolumeSource = {
        medium | Str | optional,
    },
    Volume = {
        name | Str,
        emptyDir | EmptyDirVolumeSource,
    },
    PodSpec = {
        initContainers | NameArray Container | optional,
        containers | NameArray Container,
        volumes | NameArray Volume,
    },
    PodTemplateSpec = {
        metadata | ObjectMeta,
        spec | PodSpec,
    },
    StatefulSetSpec = {
        replicas | Num | optional,
        selector | LabelSelector,
        serviceName | Str,
        template | PodTemplateSpec,
    },
    StatefulSet = {
        apiVersion = "apps/v1",
        kind = "StatefulSet",
        metadata | ObjectMeta,
        spec | StatefulSetSpec,
    },
}