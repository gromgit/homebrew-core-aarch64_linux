class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.22.2",
      revision: "da3346113a8a75e11225f586482934000504a60f"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b267743badd08ccc1de66d20f9fc9e93238de43eccfc7e800ef7ddddc29093db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc88d0d467fe50014ee1c60c9a7787b61b9fb6aa524daa620ecc23eccfb9795c"
    sha256 cellar: :any_skip_relocation, monterey:       "9288465f2b8e44f15e88bc9577c8c5fb52c2caaa353cb08fe6ff3690af4c1e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "a71bddd97b21d58949a53f7fd8c5c20c80b55d2d8c5e312144105016af2dd2a9"
    sha256 cellar: :any_skip_relocation, catalina:       "8b52499f5f54cff99233f82fa3d60bb7efe249dc77cee04b3d3457bbc548d28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77c530a04d6f29dbddb60a9ede308a5fd987e19b6766c7febe1038285d65c497"
  end

  depends_on "go"

  def install
    ENV["GOBIN"] = libexec/"bin"
    system "make", "install"

    # Install bash completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "bash")
    (bash_completion/"operator-sdk").write output

    # Install zsh completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "zsh")
    (zsh_completion/"_operator-sdk").write output

    # Install fish completion
    output = Utils.safe_popen_read(libexec/"bin/operator-sdk", "completion", "fish")
    (fish_completion/"operator-sdk.fish").write output

    output = libexec/"bin/operator-sdk"
    (bin/"operator-sdk").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      commit_regex = /[a-f0-9]{40}/
      assert_match commit_regex, version_output
    end

    mkdir "test" do
      output = shell_output("#{bin}/operator-sdk init --domain=example.com --repo=github.com/example/memcached")
      assert_match "$ operator-sdk create api", output

      output = shell_output("#{bin}/operator-sdk create api --group c --version v1 --kind M --resource --controller")
      assert_match "$ make manifests", output
    end
  end
end
