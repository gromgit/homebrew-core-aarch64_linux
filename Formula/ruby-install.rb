class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.5.tar.gz"
  sha256 "793fcf44dce375c6c191003c3bfd22ebc85fa296d751808ab315872f5ee0179b"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ruby-install"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fbf7c2aafd7ef1bfef3dcc68441c43926a6c16666f3876c6c8aa32d29e296700"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace man1/"ruby-install.1", "/usr/local", "$HOMEBREW_PREFIX"
    inreplace [
      pkgshare/"ruby-install.sh",
      pkgshare/"truffleruby/functions.sh",
      pkgshare/"truffleruby-graalvm/functions.sh",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"ruby-install"
  end
end
