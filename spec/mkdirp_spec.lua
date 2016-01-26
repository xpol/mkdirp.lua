local lfs  = require('lfs')
local mkdirp = require('mkdirp')

local isWindows
if _G.jit then
  isWindows = _G.jit.os == "Windows"
else
  isWindows = not not package.path:match("\\")
end


local shell = {}
function shell.mkdirs(p)
  if isWindows then
    os.execute('md '..p)
  else
    os.execute('mkdir -p '..p)
  end
end

function shell.rmdirs(p)
  if isWindows then
    os.execute('rd /Q /S '..p)
  else
    os.execute('rm -rf '..p)
  end
end

describe('mkdirp()', function()

  before_each(function()
    shell.mkdirs('e/x/i/s/t')
  end)
  after_each(function()
    shell.rmdirs('e')
    shell.rmdirs('c')
  end)
  it('makes directory if it does not exists', function()
    assert.is_nil(lfs.attributes('c/r/e/a/t/e', 'mode'))
    assert.is_true(mkdirp('c/r/e/a/t/e'))
    assert.are.equal('directory', lfs.attributes('c/r/e/a/t/e', 'mode'))
  end)

  it('returns nil if directory if already exists', function()
    assert.are.equal('directory', lfs.attributes('e/x/i/s/t', 'mode'))
    assert.is_nil(mkdirp('e/x/i/s/t'))
  end)
end)
