let { mkService, .. } = import "k8s-schema.ncl" in
mkService "scm" {
    spec = {
        ports.ui.port = 9876,
        clusterIP = "None",
        selector = {
            app = "ozone",
            component = "scm"
        }
    }
} 