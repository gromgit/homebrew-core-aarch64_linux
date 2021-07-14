class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.23.0.tar.gz"
  sha256 "cd23a5b7ef9189464800a89f7c1cc80ed745ba157ad00506a9996017879805bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08b3fd92d4c70b295639e7b52db0d6e4b2d09c71a69f6329072622286ca01e05"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d4bb598fa463f5d7042eab3ae179967b4073da40d4c0f602adceb9870ea3e9e"
    sha256 cellar: :any_skip_relocation, catalina:      "c28382d80c2a43f4245e2c5c72914955bdfd591710a0b94385f67b6e5ce1643c"
    sha256 cellar: :any_skip_relocation, mojave:        "0301ac410011550388da428ce15d8f33808f98e354ecfa47656ba4a0b7cdafd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f1fc9348da68b04ac04c007f8d4b1b3cbb229b35c83ab36ce43fe880cbe220"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read("#{bin}/kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
