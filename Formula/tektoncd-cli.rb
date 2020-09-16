class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.12.1.tar.gz"
  sha256 "f931aa5792a08ac628cbbcfa5c295ffdbc4989186713377583e5e595eb22a80f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "55798e44ff2ba7d7bc8784f3b9f511df11b4305218c8f00bf0db88c288b144a5" => :catalina
    sha256 "cba71338ce2db04a43c78597fa4f4763690628d688723cdc73134de6a40d9246" => :mojave
    sha256 "5a680b346397b4445559b17a44790f8b2804034d4f6df399f4ee82389e1ff8e6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
