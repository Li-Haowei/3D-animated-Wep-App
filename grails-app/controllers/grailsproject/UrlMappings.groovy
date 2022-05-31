package grailsproject

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(view:"/index")
        "/controllableCube"(view:"/controllableCube")
        "/maze"(view:"/maze")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
