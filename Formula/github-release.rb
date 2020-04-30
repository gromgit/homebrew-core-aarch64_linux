class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/v0.8.0.tar.gz"
  sha256 "abe9bf867d26736361c267114f8ece35301fe2e2f063b77e79122f6386d22bf8"
  head "https://github.com/github-release/github-release.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5efe98cdd8183f167d0e80bf674707348da4bdad39336e878d97f014d2c2484c" => :catalina
    sha256 "984db7e9b0ace7730dcc508284467c935fbd1b24f04fd13ff26e513262537b99" => :mojave
    sha256 "ef971a577e3e673602d225e5ada1caed5dde39936a4ea6362d2c411daae9ba50" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install "github-release"
  end

  test do
    system "#{bin}/github-release", "info", "--user", "github-release",
                                            "--repo", "github-release",
                                            "--tag", "v#{version}"
  end
end
