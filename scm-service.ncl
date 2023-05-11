let { Service, .. } = import "k8s-schema.ncl" in

{
    metadata.name = "scm",
    spec = {
        ports.ui.port = 9876,
        clusterIP = "None",
        selector = {
            app = "ozone",
            component = "scm"
        }
    }
} | Service