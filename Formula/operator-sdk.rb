class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.20.1",
      revision: "1780d438cfd87382d034c72703a80d9073b7b6d8"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e7fc83b305d8fd672b1a68ed04d83afb2509393e07a105ba1922d11ee491986"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "239b1ada548023fa19a593d3f15267f7e370f5e2d30cb2c4be1045aa7b21a2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd164db5f3d9e183527aa2082d096c60b1f097a05e965d8daa308842f12dab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c50a93409f48b97037f376aa565a58f3e0cd282b5d1cd730ffdbf3bb58f6fb3e"
    sha256 cellar: :any_skip_relocation, catalina:       "17820af2c0902e9b7bede2a5747a553838160a2cbe603686aaa667b798345faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e9798f46d1f7f58da65b99dfbb3a242c2e1c8720c4979ea249c1818b1a02ee"
  end

  # Resolves upstream issue: https://github.com/operator-framework/operator-sdk/issues/5689
  # Should be updated to "go" when the following upstream issue is resolved: https://github.com/operator-framework/operator-sdk/issues/5740
  depends_on "go@1.17"

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
