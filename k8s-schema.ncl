let to_name_array = fun a => array.map (fun k => { name = k } & a."%{k}") (record.fields a) in
let NamedArray = fun _contract label value =>
    contract.apply
        (Array _contract)
        label
        (if builtin.is_array value then value else to_name_array value) in

{
    ObjectMeta = {
        name | Str,
    },
    ServicePort = {
        name | Str,
        port | Num,
    },
    ServiceSpec = {
        ports | NamedArray ServicePort,
        clusterIP | Str | optional,
        selector | {_:Str},
    }, 
    Service = {
        apiVersion = "v1",
        kind = "Service",
        metadata | ObjectMeta,
        spec | ServiceSpec,
    },
}