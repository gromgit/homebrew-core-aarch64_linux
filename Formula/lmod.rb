class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://github.com/TACC/Lmod/archive/8.7.10.tar.gz"
  sha256 "efa8b995a532f8f2c67b9a032e89ac7ee51fb302b98f9d0b0554506ddcd482ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df10aac7277b91327a2640e96453d2eb687d7c942d5c6abd70a5488f946f9190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29d6ce7b5845aa9d8adbdb58ba4b5ffd1995fb5e8d07ebd93fc7f36c8033e727"
    sha256 cellar: :any_skip_relocation, monterey:       "aae69f0b1f548264ba1cf59d9968dc17ec2ca118fedf43c8c408de444542fb88"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b5d8ff95670aafa39b7acc275fc4dc079e2d0fd2c016f18100a38087bf89ba0"
    sha256 cellar: :any_skip_relocation, catalina:       "2eccc4a0884430970435bee43bfdefb2ad816db37738d6305df4f98d2cfbaa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78891bf43e4daf4eab1a6c0b38006855158a7dbeb8160451fa309b08eb6741bb"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
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
