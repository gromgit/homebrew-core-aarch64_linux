class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v1.0.0",
      revision: "d7d5e0cd6cf5468bb66e0849f08fda5bf557f4fa"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d42df09af8940d0631f4863c3ea98aa0a6a6a1d7b232da6485aaf3db681a69a0" => :catalina
    sha256 "1ddc6ab31573162d302a51dbc3aefc9ab0525a70ae1d56871fc21b1a26cdc408" => :mojave
    sha256 "45440738a87ef0ccfc1886cc99c3dbeaa6b72b931144602aa9d1b99065a015e6" => :high_sierra
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
      assert_match stable.specs[:revision], version_output
    end

    system bin/"operator-sdk", "init", "--domain=example.com", "--repo=example.com/example/example"
    assert_predicate testpath/"bin/manager", :exist?
  end
end
