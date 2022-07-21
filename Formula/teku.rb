class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.7.0",
        revision: "f65b5ae3842e255fc2b3ab95fae8dde74b34c126"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b695a79764368a2fd5cf8eb36a5da8e2ea10f862bc082e79f948446b4789a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d46732c92a68860d73264c000e40979a16cc91a0071225388de1a08ad6d51fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0b3942bab23b7d305bde57f0190cd83c1ef569f4a90be5cff4c5bf8045da6d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "5282c88da03ebd50b6b9127614dc3551234fac908a08a7378b4356b76cad6b4a"
    sha256 cellar: :any_skip_relocation, catalina:       "4ab1d11fa83a302f9f09830eb626fcb577c2eaf2a575118b04dab5747d0eeee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d594fdf3f327eb2c216aaf15f1704c7c078c2c1e306295ec6a71093f520aa159"
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
