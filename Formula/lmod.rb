class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.8.tar.gz"
  sha256 "12d0dd6f48f4edfb980286f7763c0ece55efe6de46b4fe055d93f4ef1ff6ba43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e46765c161f0e957b33ae442c16371e01a621210480e61877164322fbf0fe02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90dd25c5aba7ea27f427be2d850c36e649ec03f591b89741613824ee959a43cf"
    sha256 cellar: :any_skip_relocation, monterey:       "c9969c8ed10162d8789bc56548feb44cef9613fac2e42de454c32facd529ae41"
    sha256 cellar: :any_skip_relocation, big_sur:        "da5f47468445cc27b30d3d0d92111503d71f3c3875fd327f912b7bfe2c0529ae"
    sha256 cellar: :any_skip_relocation, catalina:       "eb4a84ad2a8d29b276d6c93e08ecfbe91d576cec4b97868e06b214e3a1c91c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aaacdc3843d547a1599cd170036defebea96beaaac725ae7c15fc24f6ef0f20"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/refs/tags/v35.1.tar.gz"
    sha256 "1b5c48d2abd59de0738d1fc1e6204e44979ad2a1a26e8e22a2d6215dd502c797"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~EOS
      #!/bin/sh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
