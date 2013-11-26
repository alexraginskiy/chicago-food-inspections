# require all tests, files with names ending in `-test`
window.require.list().filter((name)-> /-test$/.test(name)).forEach require