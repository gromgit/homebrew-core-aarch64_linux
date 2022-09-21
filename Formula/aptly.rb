class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.4.0.tar.gz"
  sha256 "4172d54613139f6c34d5a17396adc9675d7ed002e517db8381731d105351fbe5"
  license "MIT"
  revision 1
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aptly"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "94578dae1405970432cc4eecce9305bfdfe2dc491db21ec7d2bb41d894aa66a5"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/aptly-dev/aptly").install buildpath.children
    cd "src/github.com/aptly-dev/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
      bash_completion.install "completion.d/aptly"
      zsh_completion.install "completion.d/_aptly"
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
