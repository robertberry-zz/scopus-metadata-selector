({
    appDir: "app/scripts",
    baseUrl: ".",
    dir: "build/scripts",
    modules: [
        {
            name: "main"
        }
    ],
    paths: {
        jquery: "libs/jquery/jquery-min",
        underscore: "libs/underscore/underscore-min",
        backbone: "libs/backbone/backbone-min",
        text: "libs/require/text",
        Mustache: "libs/mustache/mustache",
        templates: "../templates"
    }
})