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
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/operator-sdk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f655b6414ca41a2a67d1892a0b172a70c02ccce9e5ed3a3b3f1048656c390576"
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
