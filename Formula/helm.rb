class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.3.4",
      revision: "a61ce5633af99708171414353ed49547cf05013d"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffcb6fd81bbd3d3aaa58169c592da6eeef79f35890231022f05c3074d515675d" => :catalina
    sha256 "e9f06e6b6a506564a621dab018f472da70364b5a11f29615ea268f6490fb2d7b" => :mojave
    sha256 "04e4a728be0d1141e7baf911b9dcf9b587623b31dc2ce57e461e58cd1dbf5a78" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
