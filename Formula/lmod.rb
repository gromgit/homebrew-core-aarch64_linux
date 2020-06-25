class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://www.tacc.utexas.edu/research-development/tacc-projects/lmod"
  url "https://github.com/TACC/Lmod/archive/8.3.17.tar.gz"
  sha256 "adf5976c8d18ccef3165c919e593ae777dc64312841ada8fde994f4c25c2bd31"

  bottle do
    cellar :any_skip_relocation
    sha256 "4675c1fb54a8f8556720bc6698c55671919fd9dd8ac84c98273917f3cf21f2c2" => :catalina
    sha256 "556c1996047ee4cb7f8f6ee8531385f965555d57c89445732a1e6b9d20b220c7" => :mojave
    sha256 "e398f883fbc9806035b612e4742363a7f45564ac2146eaaa05ce55fd5fd631a8" => :high_sierra
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://github.com/luaposix/luaposix/archive/v34.1.1.tar.gz"
    sha256 "7948f4ac8b953172e928753632e37ad97cc3014df74b524fe7839f71216a7e90"
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
