#
# Copyright (c) 2015 by Lifted Studios. All Rights Reserved.
#

{hasCommand} = require './spec-helper'

describe 'Package', ->
  [activationPromise, workspaceElement] = []

  beforeEach ->
    atom.config.set 'auto-copyright',
      template: 'Copyright (c) %y by %o. All Rights Reserved.'
      owner: 'Test Owner'
      buffer: 0

    spyOn(Date.prototype, 'getFullYear').andReturn 3000

    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise -> atom.packages.activatePackage('language-coffee-script')
    activationPromise = atom.packages.activatePackage('auto-copyright')

  describe 'lifecycle', ->
    executeCommand = (callback) ->
      atom.commands.dispatch(workspaceElement, "auto-copyright:insert")
      waitsForPromise -> activationPromise
      runs(callback)

    describe 'upon activation', ->
      it 'creates the commands', ->
        executeCommand ->
          expect(hasCommand(workspaceElement, 'auto-copyright:insert')).toBeTruthy()
          expect(hasCommand(workspaceElement, 'auto-copyright:update')).toBeTruthy()

    describe 'upon deactivation', ->
      beforeEach ->
        executeCommand ->
          atom.packages.deactivatePackage('auto-copyright')

      it 'deletes the commands', ->
        expect(hasCommand(workspaceElement, 'auto-copyright:insert')).toBeFalsy()
        expect(hasCommand(workspaceElement, 'auto-copyright:update')).toBeFalsy()

  describe 'when no editor is open', ->
    it 'does not crash when insert is called', ->
      atom.commands.dispatch(workspaceElement, 'auto-copyright:insert')

    it 'does not crash when update is called', ->
      atom.commands.dispatch(workspaceElement, 'auto-copyright:update')
