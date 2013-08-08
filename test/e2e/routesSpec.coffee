describe "E2E: Testing Routes", ->

  beforeEach ->
    browser().navigateTo "/"

  it "should follow the default Angular.js route when / is accessed", ->
    expect(browser().location().path()).toBe "/"
  it "should follow the default Angular.js route when #/ is accessed", ->
    browser().navigateTo "#/"
    expect(browser().location().path()).toBe "/"