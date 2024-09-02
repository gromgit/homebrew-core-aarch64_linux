class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/odo"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d8b477672674c9def7a65f77190f48ec6d3185ec21fe5bcd8f5b4bb34825482c"
  end

  conflicts_with "odo-dev", because: "odo-dev also ships 'odo' binary"

  def install
    system "make"
    man1.mkpath
    bin.mkpath
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/odo", "testlog"
  end
end
