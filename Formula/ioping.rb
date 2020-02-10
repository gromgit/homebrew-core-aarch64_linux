class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.2.tar.gz"
  sha256 "d3e4497c653a1e96df67c72ce2b70da18e9f5e3b93179a5bb57a6e30ceacfa75"
  head "https://github.com/koct9i/ioping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1225688038ff2ca15f26f6017e34b95da42be3a835a61bd7d7479776475403c1" => :catalina
    sha256 "86ccaf89bf56a5f25f3d91463794d6e26c0dd19a37f72532e6d9c475881b7756" => :mojave
    sha256 "f7ec7717b3a117c9d57ddc62649e5635311ace177db679c57798257c85cfba63" => :high_sierra
    sha256 "f2f45cdd184b2c1e8eaf401123950eb788832a2a2e4234e96e7f31566b63a9bc" => :sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
