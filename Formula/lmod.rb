class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.4.4.tar.gz"
  sha256 "69ca34712e752e678a4265abc148213332e4e345b3e9ac3bf4456054d3c8e7d4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "45d465ad1fc7dbe12a42a3a98f5be5f91e1f1db29ffe54e98076406f64f5b88f" => :catalina
    sha256 "93fe0d58b37565be50eb8f9d7212681cad15aec6c0706ed6e5e06e2bf8e2cc3a" => :mojave
    sha256 "19a13507efa746ba52f63b7845e5b03233896662c299caca172e978295fc4a53" => :high_sierra
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v35.0.tar.gz"
    sha256 "a4edf2f715feff65acb009e8d1689e57ec665eb79bc36a6649fae55eafd56809"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/5.3/?.lua;" \
                      "#{luapath}/share/lua/5.3/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

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
    system "#{prefix}/init/sh"
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end
