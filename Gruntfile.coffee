#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module.exports = (grunt) ->
  grunt.initConfig {
    codo: {
      options: {
        inputs: ['lib']
      }
    },
    shell: {
      test: {
        command: 'apm test'
      }
    }
  }

  grunt.loadNpmTasks('grunt-codo')
  grunt.loadNpmTasks('grunt-shell')
  grunt.registerTask('default', ['shell:test', 'codo'])
  grunt.registerTask('test', ['shell:test'])
