var pkgjson = require('./package.json');

var config = {
  pkg: pkgjson,
  app: 'src',
  dist: '../app/assets/',
  base: 'public'
};

module.exports = function(grunt) {

  // Configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    config: config,
    bower: grunt.file.readJSON('./.bowerrc'),
    shell: {
      patternlab: {
        command: "php core/builder.php -gp"
      },
      patterngenerate: {
        command: "php core/builder.php -g"
      },
      rsync: {
        command: [
          "rsync -vr source/css/scss/ "+ config.dist + "stylesheets/scss/",
          "rsync -vr source/css/style.scss "+ config.dist + "stylesheets/_style.scss",
        ].join('&&')
      },
    },
    sass: {
      options: {
        sourceMap: true,
        outputStyle: 'compressed'
      },
      dist: {
        options: {
            style: 'compressed'
        },
        files: {
            'public/css/style.css': 'source/css/style.scss',
            'public/styleguide/css/styleguide.css': 'public/styleguide/css/styleguide.scss',
            'public/styleguide/css/styleguide-specific.css': 'public/styleguide/css/styleguide-specific.scss'
        }
      }
    },
    uglify: {
      options: {
        beautify: true,
        mangle  : false,
        banner: '/*! <%= grunt.template.today("dd-mm-yyyy, h:MM:ss") %> */ \n',
      },
      dist: {
        files: {
          'source/js/main.js': [
            'source/js/src/console-fix.js',
            'source/js/src/scripts.js'
          ]
        }
      }
    },
    connect: {
      server: {
        options: {
          port: 8081,
          hostname: 'localhost',
          base: config.base
        }
      }
    },
    watch: {
      html: {
          files: [
            'source/_patterns/**/*.mustache',
            'source/_patterns/**/*.json',
          ],
          tasks: [ 'shell:patternlab' ]
      },
      js: {
          files: [
            'source/js/plugins/*.js',
            'source/js/src/*.js',
          ],
          tasks: [ 'uglify', 'shell:patternlab', 'sass' ],
      },
      css: {
          files: [
            'source/css/*.scss',
            'source/css/**/*.scss',
            'public/styleguide/css/**/*.scss'
          ],
          tasks: [ 'shell:patterngenerate', 'sass']
      },
      rsync: {
        files: [ 'source/**' ],
        tasks: [ 'shell:rsync' ]
      },
      options: {
          spawn: false,
          livereload: false
      }
    }
  });

  // Plugins
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-sass');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-notify');

  // Tasks
  grunt.registerTask('default', [ 'connect', 'uglify', 'sass', 'shell:patternlab', 'shell:rsync', 'watch' ]);
  grunt.registerTask('no-server', [ 'uglify', 'sass', 'shell:patternlab','shell:rsync', 'watch' ]);
};