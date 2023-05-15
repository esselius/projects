let { K8sManifests, mkStatefulService, .. } = import "utils.ncl" in

let defaultEnv = {
    "OZONE-SITE.XML_dfs.datanode.use.datanode.hostname".value = "true",
    "OZONE-SITE.XML_hdds.datanode.dir".value = "/data/storage",
    "OZONE-SITE.XML_hdds.scm.safemode.min.datanode".value = "3",
    "OZONE-SITE.XML_ozone.datanode.pipeline.limit".value = "1",
    "OZONE-SITE.XML_ozone.metadata.dirs".value = "/data/metadata",
    "OZONE-SITE.XML_ozone.om.address".value = "om",
    "OZONE-SITE.XML_ozone.scm.block.client.address".value = "scm",
    "OZONE-SITE.XML_ozone.scm.client.address".value = "scm",
    "OZONE-SITE.XML_ozone.scm.datanode.id.dir".value = "/data",
    "OZONE-SITE.XML_ozone.scm.names".value = "scm",
} in

{
    ozone = {
        s3g = mkStatefulService {
            volume = "/data",
            image = "apache/ozone",
            run = "ozone s3g",
            ports = {
                http = 9878,
            },
            env = defaultEnv,
        },
        recon = mkStatefulService {
            volume = "/data",
            image = "apache/ozone",
            run = "ozone recon",
            ports = {
                http = 9888,
                datanode-rpc = 9891,
            },
            env = defaultEnv,
        },
        scm = mkStatefulService {
            volume = "/data",
            image = "apache/ozone",
            init = "ozone scm --init",
            run = "ozone scm",
            ports = {
                client-rpc = 9860,
                datanode-rpc = 9861,
                block-rpc = 9863,
                http = 9876,
            },
            env = defaultEnv,
        },
        datanode = mkStatefulService {
            image = "apache/ozone",
            volume = "/data",
            run = "ozone datanode",
            ports = {
                http = 9882,
                rpc = 9870,
            },
            env = defaultEnv,
            replicas = 3,
        },
        om = mkStatefulService {
            image = "apache/ozone",
            volume = "/data",
            run = "ozone om",
            ports = {
                rpc = 9862,
                http = 9874,
            },
            env = defaultEnv & {
                "WAITFOR".value = "scm:9876",
                "ENSURE_OM_INITIALIZED".value = "/data/metadata/om/current/VERSION",
            },
        },
    },
} | K8sManifests