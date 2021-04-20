class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.3.0.tar.gz"
  sha256 "c5f77d50eeda704a228f30f5a233ef0e56ef9f4cc83433d46e331b3247d28c6d"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54dcd27b35469e1484f5ef6d13af998417f9c6596dd42b2485f3a33d4186c127"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7fc3bb98099bcadde6818634cbc4d3b3440e2b1f8672b9a62cef90a14a7c3c5"
    sha256 cellar: :any_skip_relocation, catalina:      "bbdf301eacbdf973d706caf49406bd1b281b6e48c94ec7105584a3f1e9d85b8b"
    sha256 cellar: :any_skip_relocation, mojave:        "3e96a263147ce3bb4b210f546355160b30f14d319ce49746663960e622db2487"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/github/git-sizer").install buildpath.children
    cd "src/github.com/github/git-sizer" do
      system "go", "build", *std_go_args(ldflags: "-X main.ReleaseVersion=#{version}")
      prefix.install_metafiles
    end
  end

  test do
    system "git", "init"
    output = shell_output("#{bin}/git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end
