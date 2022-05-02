class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.20.0",
      revision: "deb3531ae20a5805b7ee30b71f13792b80bd49b1"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb309ebb6dc58aa4d24d2cce10eab98b455d0f567b4dadfc0cc3e3c15e5fca44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b58d271cea0166c27e50b8ad0c0adc006ccb13db37e619ca5bffa1e847234132"
    sha256 cellar: :any_skip_relocation, monterey:       "93f4f5926140c39a6809a6aa1a9d3729c995f41680e9fafe7548c68366560c07"
    sha256 cellar: :any_skip_relocation, big_sur:        "3be9656a780de59778bce70d1b22a7d4c9c73bfa9a46bb15ad9a1210398cfadb"
    sha256 cellar: :any_skip_relocation, catalina:       "9c88e8c1d33c6457c8ed22a4abb510f1cbdf14de52565fabf06ab73bedcc345d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab8c291e0dad800d4405f56002ba1252c13eb4b91e8d4b563b95da33b3a472f"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    output = shell_output("#{bin}/operator-sdk init --domain=example.com --license apache2 --owner BrewTest 2>&1", 1)
    assert_match "failed to initialize project", output
  end
end
