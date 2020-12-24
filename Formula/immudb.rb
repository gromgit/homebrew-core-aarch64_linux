class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.8.1.tar.gz"
  sha256 "a720cdce8888935ed99e2c1aefb1608508b70a374fc62f3434e38392267d65ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1af460fb4aaa435eab45d7eea56985d6dc5b11969f379b7f852bb1b8ff801bac" => :big_sur
    sha256 "fa7212e07386dd14029400cee8dfe2e5ebe1483f9e55ba03ecc9fc97788feab2" => :catalina
    sha256 "975bd32bec4bbdfdfa78b6ebe809a5ccae0deb4ab2d80e8280a28feb3bd22df7" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  test do
    immudb_port = free_port

    fork do
      exec bin/"immudb", "--auth=false", "-p", immudb_port.to_s
    end
    sleep 3

    system bin/"immuclient", "safeset", "hello", "world", "-p", immudb_port.to_s
    assert_match "world", shell_output("#{bin}/immuclient safeget hello -p #{immudb_port}")

    assert_match "OK", shell_output("#{bin}/immuadmin status -p #{immudb_port}")
  end
end
