class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.4.0",
        revision: "4097026e4cfff4442aa274882a56c160454f2503"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "570c6ff9dde583bed4a1321ead4675b9a5e2949b6f91623216262900a978f8f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7c9478c17cd2abc5af293f1c791abf5682e52ef4752054520ada62ab623c63"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1f0426c7808560b072c37ec8adede661b81e72fc2d1316bc99764f664147d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5de8f384ab6189416a1e2601de140b6ede0cf3f36ee94143195ac001e628d1b"
    sha256 cellar: :any_skip_relocation, catalina:       "53abe53f5049957d2e5bd9938230f80abddea37f7a0d698f4bda87e0a5ad5ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18cc256c28ad9ee6d2aea350acda31f4cb57762c5a65591cde08fefe60ada602"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
