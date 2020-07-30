class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk.git",
      tag:      "v0.19.2",
      revision: "4282ce9acdef6d7a1e9f90832db4dc5a212ae850"
  license "Apache-2.0"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcc829e86973ba053b4cf52c1dbe1f5b86b5d3ae85052b8a7ccebf241a61e7c8" => :catalina
    sha256 "d220ae570b6ad5c4aef9ed357a2a384cf93bdcaa5c5f6657dec8853ae6e509f9" => :mojave
    sha256 "3a0e077dc1b815f17e7ee31104f1400148408c0b328c00f7d526b39ac90b779d" => :high_sierra
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
    # Use the offical golang module cache to prevent network flakes and allow
    # this test to complete before timing out.
    ENV["GOPROXY"] = "https://proxy.golang.org"

    if build.stable?
      version_output = shell_output("#{bin}/operator-sdk version")
      assert_match "version: \"v#{version}\"", version_output
      assert_match stable.specs[:revision], version_output
    end

    # Create an example AppService operator. This exercises most of the various pieces
    # of generation logic.
    args = ["--type=ansible", "--api-version=app.example.com/v1alpha1", "--kind=AppService"]
    system "#{bin}/operator-sdk", "new", "test", *args
    assert_predicate testpath/"test/requirements.yml", :exist?
  end
end
