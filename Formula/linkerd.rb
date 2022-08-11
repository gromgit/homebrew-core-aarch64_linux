class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.12.0",
      revision: "0bd3f732e68b9bc0345b801ca541fad36a8dd824"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e5dfe2e143f21fc5215f2e0f13f256ac7650bf91cd93ebc50a2d4f7e3d380e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3559d9295ee5a3ed1511e0844cf4ab3f8083b5e3b8acb4912c3ce578404305bc"
    sha256 cellar: :any_skip_relocation, monterey:       "10122413c6c4630f84cf2172714efc7bea20fd4e95cddab3393495a99da3e935"
    sha256 cellar: :any_skip_relocation, big_sur:        "b565d1a74392e36bee0d87b9a3b294146ae81d24d7e3cecb7ee9f74be3a82076"
    sha256 cellar: :any_skip_relocation, catalina:       "44bc8d80ea6026f05547cd16c695fe3febc66204eaa9821125a0bed8f6457dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a60324e1189844470383f1ffb9417e2241696c7d52af10f6473286d04134d5"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
