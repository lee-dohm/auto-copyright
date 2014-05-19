#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-shell')

  grunt.initConfig {
    shell: {
      doc: {
        doc: 'biscotto'
      }
      lint: {
        command: 'coffeelint lib/*'
      }
      spec: {
        command: 'apm test'
      }
    }
  }

  grunt.registerTask('default', ['spec', 'shell:doc'])
  grunt.registerTask('spec', ['shell:lint', 'shell:spec'])
  grunt.registerTask('test', ['spec'])
