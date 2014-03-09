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
      lint: {
        command: 'coffeelint lib/*'
      }
      spec: {
        command: 'apm test'
      }
    }
  }

  grunt.loadNpmTasks('grunt-codo')
  grunt.loadNpmTasks('grunt-shell')
  grunt.registerTask('default', ['spec', 'codo'])
  grunt.registerTask('spec', ['shell:lint', 'shell:spec'])
  grunt.registerTask('test', ['spec'])
