require '../config'

scope  = null

describe 'Tower.Model.Scope', ->
  beforeEach ->
    User.store(new Tower.Store.Memory(name: "users", type: "User"))
    scope = User.scoped()
    
  afterEach ->
    scope = null
  
  describe '#find', ->
    test '`1, 2, 3`', ->
      spyOn scope.store, "find"
      scope.find 1, 2, 3
      
      expect(scope.store.find).toHaveBeenCalledWith {id: $in: [1, 2, 3]}, {}, undefined
      
    test '`[1, 2, 3]`', ->
      spyOn scope.store, "find"
      scope.find [1, 2, 3]
      
      expect(scope.store.find).toHaveBeenCalledWith {id: $in: [1, 2, 3]}, {}, undefined
      
    test '`[1, 2, 3], callback`', ->
      callback = ->
      
      spyOn scope.store, "find"
      scope.find [1, 2, 3], callback
      
      expect(scope.store.find).toHaveBeenCalledWith {id: $in: [1, 2, 3]}, {}, callback
      
    test 'where(id: $in: [1, 2, 3]).find(1) should only pass id: $in: [1]', ->
      spyOn scope.store, "find"
      scope.where(id: $in: [1, 2, 3]).find(1)
      
      expect(scope.store.find).toHaveBeenCalledWith {id: $in: [1]}, {}, undefined
      
  describe '#update', ->
    test '`1, 2, 3`', ->
      spyOn scope.store, "update"
      scope.update 1, 2, 3, {name: "Lance"}, instantiate: false
      
      expect(scope.store.update).toHaveBeenCalledWith { name : 'Lance' }, { id : { $in : [ 1, 2, 3 ] } }, {}, undefined 
      
    test '`[1, 2, 3]`', ->
      spyOn scope.store, "update"
      scope.update 1, 2, 3, {name: "Lance"}, instantiate: false

      expect(scope.store.update).toHaveBeenCalledWith { name : 'Lance' }, { id : { $in : [ 1, 2, 3 ] } }, {}, undefined 
      
  describe '#delete', ->
    test '`1, 2, 3`', ->
      spyOn scope.store, "delete"
      scope.delete 1, 2, 3, instantiate: false
      
      expect(scope.store.delete).toHaveBeenCalledWith { id : { $in : [ 1, 2, 3 ] } }, {}, undefined 
      
    test '`[1, 2, 3]`', ->
      spyOn scope.store, "delete"
      scope.delete 1, 2, 3, instantiate: false
      
      expect(scope.store.delete).toHaveBeenCalledWith  { id : { $in : [ 1, 2, 3 ] } }, {}, undefined 
      
    test 'query + ids', ->
      spyOn scope.store, "delete"
      scope.where(name: "John").delete 1, 2, 3, instantiate: false
      
      expect(scope.store.delete).toHaveBeenCalledWith  { name: "John", id : { $in : [ 1, 2, 3 ] } }, {}, undefined
      
  describe '#create', ->
    test 'create(name: "Lance")', ->
      spyOn scope.store, "create"
      scope.create(name: "Lance")
      
      expect(scope.store.create).toHaveBeenCalledWith { name: "Lance" }, {}, undefined
      
    test 'where(name: "Lance").create()', ->
      spyOn scope.store, "create"
      scope.where(name: "Lance").create()
      
      expect(scope.store.create).toHaveBeenCalledWith { name: "Lance" }, {}, undefined
      
    test 'create with an `id`', ->
      spyOn scope.store, "create"
      scope.create id: "something"

      expect(scope.store.create).toHaveBeenCalledWith { id: "something" }, {}, undefined
      
  test '#clone', ->
    clone = scope.where(name: "Lance")
    clone2 = clone.where(email: "example@gmail.com")
    
    expect(clone.criteria.query).toNotEqual scope.criteria.query
    expect(clone2.criteria.query).toEqual name: "Lance", email: "example@gmail.com"
    expect(clone.criteria.query).toEqual name: "Lance"
    expect(scope.criteria.query).toEqual {}
    