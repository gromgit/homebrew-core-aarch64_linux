class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.4.0",
      revision: "67f9c8b888887d18cd38bb6fd85cf3cf5b94fd99"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    sha256 arm64_big_sur: "a5c000656cb126a8d6397fadafb9411b3ba81d9ace4c082423153ee7e63705d5"
    sha256 big_sur:       "9e61b0ea0edb9f1e9565efffe0e73f516ffe49d77faf3dad95cee7e49cf6a0e5"
    sha256 catalina:      "eed2388cc5f42c6ae7644aed1432f35bf857ac8a1f12b9b05e2f6ffc68edccf1"
    sha256 mojave:        "b1709956e6097986e20600c9d7f1adc25e39839899ea829b6e767773d8c12917"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output
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
