let to_name_array = fun a => array.map (fun k => { name = k } & a."%{k}") (record.fields a) in
{
    ObjectMeta = {
        name | Str,
    },
    ServicePort = {
        name | Str,
        port | Num,
    },
    ServiceSpec = {
        ports | Array ServicePort,
        clusterIP | Str | optional,
        selector | {_:Str},
    }, 
    Service = {
        apiVersion = "v1",
        kind = "Service",
        metadata | ObjectMeta,
        spec | ServiceSpec,
    },
    mkService = fun name svc => { metadata.name = name } &
        record.update "spec" (
            record.update "ports" (
                to_name_array svc.spec.ports
            ) svc.spec
        ) svc | Service
}