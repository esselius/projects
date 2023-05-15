let { StatefulSet, Service, ServicePort, EnvVar, Container, .. } = import "k8s-schema.ncl" in

{
    to_name_array = fun a => a
        |> record.fields
        |> array.map (fun k => { name = k } & a."%{k}"),

    NameArray = fun _contract label value =>
        if builtin.is_array value
        then value
        else to_name_array value | Array _contract,

    SplitArrayStr = fun label value =>
        if builtin.is_array value
        then value
        else string.split " " value | Array Str,

    mkStatefulService = fun a labels => 
        [
            {
                metadata.name = labels.component,
                spec = {
                    replicas = getOrDefault "replicas" a a.replicas 1,
                    selector.matchLabels = labels,
                    serviceName = labels.component,
                    template = {
                        metadata.labels = labels,
                        spec = {
                            containers.main = {
                                image = a.image,
                                args = a.run,
                                volumeMounts.main.mountPath = a.volume,
                                env = getOrDefault "env" a a.env {},
                                ports = record.map (fun k v => { containerPort = v }) a.ports,
                            },

                            volumes.main.emptyDir = {},
                        },
                    },
                },
            } & (
                getOrDefault "init" a {
                    spec.template.spec.initContainers.init = {
                        image = a.image,
                        args = a.init,
                        volumeMounts.main.mountPath = a.volume,
                        env = getOrDefault "env" a a.env {},
                    },
                } {}
            ) | StatefulSet,
            {
                metadata.name = labels.component,
                spec = {
                    ports = record.map (fun k v => { port = v }) a.ports,
                    clusterIP = "None",
                    selector = labels,
                },
            } | Service,

        ],

    getOrDefault = fun field _record value _default =>
        if record.has_field field _record
        then value
        else _default,

    K8sManifests = fun label value =>
        let q = fun f r => array.flatten (array.flatten (array.map (fun a => array.map ((f) a) (record.fields r."%{a}")) (record.fields r))) in
        q (fun a b => value."%{a}"."%{b}" { app = a, component = b }) value |> yaml_multi_doc,

    yaml_multi_doc = fun a =>
        string.join
            ""
            (array.map (builtin.serialize `Yaml) a),

    StrLength = fun min max label value =>
        if string.length value >= min &&
            string.length value <= max
        then value
        else
            contract.blame label,
}