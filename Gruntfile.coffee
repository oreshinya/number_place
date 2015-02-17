module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-bower-concat'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.initConfig
    bower_concat:
      all:
        dest: "cordova/www/vendor.js"
        bowerOptions:
          relative: false

    browserify:
      app:
        files:
          "cordova/www/all.js": [
            "app/**/*.coffee"
          ]
        options:
          transform: ["coffeeify", "partialify", "uglifyify"]

      spec:
        files: 
          "spec/build/test.js": [
            "spec/src/**/*.spec.coffee"
          ]
        options:
          transform: ["coffeeify"]

    karma:
      unit:
        options:
          frameworks: [
            'mocha',
            'sinon-chai'
          ]
          files: ["spec/build/test.js"]
          browsers: ['PhantomJS']
          reporters: "spec"
          singleRun: true

    compass:
      dist:
        options:
          sassDir: "app/styles"
          specify: "app/styles/all.scss"
          cssDir: "cordova/www"
          require: ["animation"]
          outputStyle: "compressed"

    esteWatch:
      options:
        dirs: [
          "app/**/"
          "spec/**/"
        ]
      coffee: (filepath) ->
        ["buildweb"]
      html: (filepath) ->
        ["buildweb"]
      scss: (filepath) ->
        ["compass"]

    shell:
      cordovaRun:
        command: (platform) ->
          "cd cordova && cordova run #{platform}"
      cordovaBuild:
        command: (platform, env) ->
          "cd cordova && cordova build #{platform} --#{env}"

  grunt.registerTask "buildweb", ["bower_concat", "browserify", "compass", "karma"]
  grunt.registerTask "watch", ["esteWatch"]

  grunt.registerTask "run", (platform) ->
    grunt.fail.warn "usage example: grunt run:android" if not platform?
    grunt.task.run "buildweb"
    grunt.task.run "shell:cordovaRun:#{platform}"

  grunt.registerTask "build", (platform, env) ->
    grunt.fail.warn "usage example: grunt build:android:release" if not platform? or not env?
    grunt.task.run "buildweb"
    grunt.task.run "shell:cordovaBuild:#{platform}:#{env}"


  # 以下、アプリ用タスク
  grunt.registerTask "checkPuzzlesUniqueness", ->
    _ = require("underscore")
    puzzles = grunt.file.readJSON("./data/puzzles.json")
    puzzleQuestions = []
    puzzleSolutions = []
    for puzzle in puzzles
      puzzleQuestions.push JSON.stringify(puzzle.question)
      puzzleSolutions.push JSON.stringify(puzzle.solution)

    puzzleQuestionsUniqueness = (_.uniq(puzzleQuestions).length is puzzles.length)
    puzzleSolutionsUniqueness = (_.uniq(puzzleSolutions).length is puzzles.length)
    grunt.log.writeln "puzzleQuestionsUniqueness: #{puzzleQuestionsUniqueness}"
    grunt.log.writeln "puzzleSolutionsUniqueness: #{puzzleSolutionsUniqueness}"
    if not puzzleQuestionsUniqueness or not puzzleSolutionsUniqueness
      grunt.fail.fatal "Puzzles are not unique!Confirm puzzles.json!"

  grunt.registerTask "generatePuzzle", (generationNumber) ->
    grunt.fail.warn "usage: grunt generatePuzzle:[generationNumber]" if not generationNumber?
    puzzles = grunt.file.readJSON("./data/puzzles.json")
    if not puzzles? or puzzles.length <= 0
      puzzles = []
      maxPuzzleId = 0
    else
      maxPuzzleId = puzzles[puzzles.length-1].id

    sudokuGenerator = require("sudoku")
    for i in [1..(generationNumber)]
      puzzleId = maxPuzzleId + i
      puzzleQuestion = sudokuGenerator.makepuzzle()
      puzzleSolution = sudokuGenerator.solvepuzzle(puzzleQuestion)
      puzzles.push
        id: puzzleId
        question: puzzleQuestion
        solution: puzzleSolution
        cleared: false
        time: 0

    puzzlesJSON = JSON.stringify(puzzles)
    grunt.file.write("./data/puzzles.json", puzzlesJSON)
    grunt.task.run("checkPuzzlesUniqueness")
