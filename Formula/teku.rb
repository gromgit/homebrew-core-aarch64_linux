class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.5.2",
        revision: "dcd3bc009c37c1cc9ec6f4c19fa772453c9298be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b396f631e3a06f0899e9780eae6b3c29ccf9f46122fcc81c353607ce92cea5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1e2c12635180afc3f3a5d70acebc01f3543c17e33b69301a23ce10c604ea46"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b750c1f34ca4fbedbf3becd2c72dad7a760a3dc530481a35c9c960110f5fd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6556bce986d4b7440bb4aa027034ebbf1b8bd4acd30450f3307785bb4425ef91"
    sha256 cellar: :any_skip_relocation, catalina:       "87381f23bb8faacff0d8144be66587ad4a16e57efa0aec7b2e10dd4f084d5d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb4a7067430a6bc50886f601b955908c24635a49c78e99185dab987e821eaff5"
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
