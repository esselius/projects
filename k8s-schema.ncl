let to_name_array = fun a => array.map (fun k => { name = k } & a."%{k}") (record.fields a) in
let NamedArray = fun label value => if builtin.is_array value then value else to_name_array value in
{
    ObjectMeta = {
        name | Str,
    },
    ServicePort = {
        name | Str,
        port | Num,
    },
    ServiceSpec = {
        ports | NamedArray
              | Array ServicePort,
        clusterIP | Str | optional,
        selector | {_:Str},
    }, 
    Service = {
        apiVersion = "v1",
        kind = "Service",
        metadata | ObjectMeta,
        spec | ServiceSpec,
    },
    mkService = fun name svc => { metadata.name = name } & svc | Service
}