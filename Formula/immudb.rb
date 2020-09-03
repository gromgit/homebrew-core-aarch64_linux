class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.7.1.tar.gz"
  sha256 "5f112d17ad62f0c6e33d83b7c88c2920e1785cef250b8bbed3e4b068bbc51350"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfbce54ccbcaf6d248b364617f027f480c8ba433663157fdd9dc3f3df976c341" => :catalina
    sha256 "f8259385cafe85d377618b9eb62487242e4750fd12182aef30a81e6cd0a4ae4f" => :mojave
    sha256 "d1d91c2269d7d53b1c61377a870af664f9f3d93e33eb6de3ecea24b9a1be2705" => :high_sierra
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
