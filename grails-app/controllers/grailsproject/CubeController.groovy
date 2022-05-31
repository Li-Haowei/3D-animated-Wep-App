package grailsproject

class CubeController {
    static defaultAction = "controllableCube"
    def index() { }

    def display(){
        render(view: 'controllableCube/controllableCube')
    }
}
