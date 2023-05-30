let { NameArray, SplitArrayString, StringLength, .. } = import "utils.ncl" in

{
    ObjectMeta = {
        name | String| optional,
        labels | {_:String} | optional,
    },
    ServicePort = {
        name | String,
        port | Number,
    },
    ServiceSpec = {
        ports | NameArray ServicePort,
        clusterIP | String| optional,
        selector | {_:String},
    }, 
    Service = {
        apiVersion = "v1",
        kind = "Service",
        metadata | ObjectMeta,
        spec | ServiceSpec,
    },
    LabelSelector = {
        matchLabels | {_:String},
    },
    EnvVar = {
        name | String,
        value | String,
    },
    VolumeMount = {
        name | String,
        mountPath | String,
    },
    ContainerPort = {
        name | String| StringLength 1 15,
        containerPort | Number,
    },
    Container = {
        name | String,
        image | String,
        args | SplitArrayString,
        env | NameArray EnvVar | optional,
        volumeMounts | NameArray VolumeMount,
        ports | NameArray ContainerPort | optional,
    },
    EmptyDirVolumeSource = {
        medium | String| optional,
    },
    Volume = {
        name | String,
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
        replicas | Number | optional,
        selector | LabelSelector,
        serviceName | String,
        template | PodTemplateSpec,
    },
    StatefulSet = {
        apiVersion = "apps/v1",
        kind = "StatefulSet",
        metadata | ObjectMeta,
        spec | StatefulSetSpec,
    },
}