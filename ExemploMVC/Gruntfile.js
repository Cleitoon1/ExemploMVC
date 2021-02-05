module.exports = function (grunt) {
    grunt.initConfig({
        minifyHtml:
        {
            Html: {
                src: ['wwwroot/Htmlfiles/**/*.html'],
                dest: 'wwwroot/Compressedfiles/',
                expand: true,
                flatten: true
            }
        }
    });
    grunt.loadNpmTasks("grunt-minify-html");

    // A very basic default task.
    grunt.registerTask('default', 'Task Description', function () {
        grunt.log.write('Welcome to Grunt js in Visual Studio');
    });

};

